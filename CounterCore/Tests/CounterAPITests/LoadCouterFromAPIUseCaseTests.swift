//
//  LoadCouterFromAPIUseCaseTests.swift
//  
//
//  Created by Thales Frigo on 27/05/21.
//

import XCTest
import CounterCore
import CounterTests
@testable import CounterAPI

final class LoadCouterFromAPIUseCaseTests: XCTestCase {
    
    func testInitDoesNotTriggerAnyCall() {
        let (_, client) = makeSUT()
        XCTAssertEqual(client.requests, [])
    }
    
    func testLoadFailsOnRequestError() {
        let (sut, client) = makeSUT()
        let apiError = anyNSError()
        
        expect(sut, toCompleteWith: .failure(apiError)) {
            client.stubRequest(with: apiError)
        }
        
        XCTAssertEqual(client.requests.count, 1)
    }
    
    func testLoadDeliversNoCounterOnEmptyData() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .success([])) {
            client.stubRequest(with: (makeEmptyCountersJSON(), .OK))
        }
        
        XCTAssertEqual(client.requests.count, 1)
    }
    
    func testLoadDeliversRemoteCountersOnValidData() {
        let (sut, client) = makeSUT()
        let counters = [
            Counter(id: "asdf", title: "boop", count: 4),
            Counter(id: "zxcv", title: "steve", count: 3),
            Counter(id: "qwer", title: "bob", count: 0),
        ]
        
        expect(sut, toCompleteWith: .success(counters)) {
            client.stubRequest(with: (makeNonEmptyCountersJson(), .OK))
        }
        
        XCTAssertEqual(client.requests.count, 1)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: RemoteCounterLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteCounterLoader(client: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, client)
    }
    
    private func expect(
        _ sut: RemoteCounterLoader,
        toCompleteWith expectedResult: Result<[Counter], Error>,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        action()
        
        var receivedResult: Result<[Counter], Error>?
        
        sut.load { receivedResult = $0 }
        
        switch (receivedResult, expectedResult) {
        case let (.success(received), .success(expected)):
            XCTAssertEqual(received, expected, file: file, line: line)
            
        case let (.failure(received as NSError), .failure(expected as NSError)):
            XCTAssertEqual(received, expected, file: file, line: line)
            
        default:
            XCTFail("Expected result \(expectedResult), got \(String(describing: receivedResult)) instead", file: file, line: line)
        }
    }
    
    private func makeEmptyCountersJSON() -> Data {
        return try! JSONSerialization.data(withJSONObject: [], options: [])
    }
    
    private func makeNonEmptyCountersJson() -> Data {
        let json = [
            ["id": "asdf", "title": "boop", "count": 4],
            ["id": "zxcv", "title": "steve", "count": 3],
            ["id": "qwer", "title": "bob", "count": 0]
        ]
        return try! JSONSerialization.data(withJSONObject: json, options: [])
    }
}

