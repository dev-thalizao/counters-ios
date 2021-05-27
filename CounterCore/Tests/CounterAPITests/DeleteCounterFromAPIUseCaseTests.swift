//
//  DeleteCounterFromAPIUseCaseTests.swift
//  
//
//  Created by Thales Frigo on 27/05/21.
//

import XCTest
import CounterCore
import CounterTests
@testable import CounterAPI

final class DeleteCounterFromAPIUseCaseTests: XCTestCase {

    func testInitDoesNotTriggerAnyCall() {
        let (_, client) = makeSUT()
        XCTAssertEqual(client.requests, [])
    }
    
    func testDeleteFailsOnRequestError() {
        let (sut, client) = makeSUT()
        let apiError = anyNSError()
        
        expect(sut, toCompleteWith: .failure(apiError)) {
            client.stubRequest(with: apiError)
        }
        
        XCTAssertEqual(client.requests.count, 3)
    }
    
    func testDeleteSucceedsOnSuccessfulRequest() {
        let (sut, client) = makeSUT()
        
        var counters = [
            Counter(id: "expect-id1", title: "expect-id1", count: 0),
            Counter(id: "expect-id2", title: "expect-id2", count: 0)
        ]

        expect(sut, toCompleteWith: .success(())) {
            client.stubRequest { (request) -> Result<(Data, HTTPURLResponse), Error> in
                return Result {
                    let request = try JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]
                    let id = request!["id"] as! String
                    
                    counters.removeAll(where: { $0.id == id })
                    
                    let json = counters.map({ counter -> [String: Any] in
                        return ["id": counter.id, "title": counter.title, "count": counter.count]
                    })
                    
                    let data = try JSONSerialization.data(withJSONObject: json, options: [])
                    return (data, .OK)
                }
            }
        }
        
        XCTAssertEqual(client.requests.count, 3)
    }
    
    func testDeleteFailsOnMidleBrokenRequest() {
        let (sut, client) = makeSUT()
        
        var counters = [
            Counter(id: "expect-id1", title: "expect-id1", count: 0),
            Counter(id: "expect-id2", title: "expect-id2", count: 0),
            Counter(id: "expect-id3", title: "expect-id3", count: 0)
        ]
        
        let apiError = anyNSError()

        expect(sut, toCompleteWith: .failure(anyNSError())) {
            client.stubRequest { (request) -> Result<(Data, HTTPURLResponse), Error> in
                return Result {
                    let request = try JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]
                    let id = request!["id"] as! String
                    
                    guard id != "expect-id3" else {
                        throw apiError
                    }
                    
                    counters.removeAll(where: { $0.id == id })
                    
                    let json = counters.map({ counter -> [String: Any] in
                        return ["id": counter.id, "title": counter.title, "count": counter.count]
                    })
                    
                    let data = try JSONSerialization.data(withJSONObject: json, options: [])
                    return (data, .OK)
                }
            }
        }
        
        XCTAssertEqual(client.requests.count, 3)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: RemoteCounterEraser, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteCounterEraser(client: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, client)
    }
    
    private func expect(
        _ sut: RemoteCounterEraser,
        toCompleteWith expectedResult: Result<Void, Error>,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        action()
        
        var receivedResult: Result<Void, Error>?
        
        sut.erase(["expect-id1", "expect-id2", "expect-id3"]) { receivedResult = $0 }
        
        switch (receivedResult, expectedResult) {
        case (.success, .success):
            XCTAssertTrue(true)
            
        case let (.failure(received as NSError), .failure(expected as NSError)):
            XCTAssertEqual(received, expected, file: file, line: line)
            
        default:
            XCTFail("Expected result \(expectedResult), got \(String(describing: receivedResult)) instead", file: file, line: line)
        }
    }
}
