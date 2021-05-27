//
//  IncrementCounterFromAPIUseCaseTests.swift
//
//
//  Created by Thales Frigo on 27/05/21.
//

import XCTest
import CounterCore
import CounterTests
@testable import CounterAPI

final class DecrementCounterFromAPIUseCaseTests: XCTestCase {

    func testInitDoesNotTriggerAnyCall() {
        let (_, client) = makeSUT()
        XCTAssertEqual(client.requests, [])
    }
    
    func testDecrementFailsOnRequestError() {
        let (sut, client) = makeSUT()
        let apiError = anyNSError()
        
        expect(sut, toCompleteWith: .failure(apiError)) {
            client.stubRequest(with: apiError)
        }
        
        XCTAssertEqual(client.requests.count, 1)
    }
    
    func testDecrementSucceedsOnSuccessfulRequest() {
        let (sut, client) = makeSUT()
        let counter = Counter(id: "expect-id", title: "expect-title", count: 1)
        
        expect(sut, toCompleteWith: .success(counter.removing())) {
            client.stubRequest(with: (makeNonEmptyCountersJson(), .OK))
        }
        
        XCTAssertEqual(client.requests.count, 1)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #filePath, line: UInt = #line
    ) -> (sut: RemoteCounterDecrementer, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteCounterDecrementer(client: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, client)
    }
    
    private func expect(
        _ sut: RemoteCounterDecrementer,
        toCompleteWith expectedResult: Result<Counter, Error>,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        action()
        
        var receivedResult: Result<Counter, Error>?
        
        sut.decrement("expect-id") { receivedResult = $0 }
        
        switch (receivedResult, expectedResult) {
        case let (.success(received), .success(expected)):
            XCTAssertEqual(received, expected, file: file, line: line)
            
        case let (.failure(received as NSError), .failure(expected as NSError)):
            XCTAssertEqual(received, expected, file: file, line: line)
            
        default:
            XCTFail("Expected result \(expectedResult), got \(String(describing: receivedResult)) instead", file: file, line: line)
        }
    }
    
    private func makeNonEmptyCountersJson() -> Data {
        let json = [
            ["id": "expect-id", "title": "expect-title", "count": 0],
            ["id": "unexpect-id", "title": "unexpect-title", "count": 3]
        ]
        return try! JSONSerialization.data(withJSONObject: json, options: [])
    }
}

