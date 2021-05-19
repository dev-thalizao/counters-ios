//
//  IncrementCounterFromCacheUseCaseTests.swift
//  
//
//  Created by Thales Frigo on 19/05/21.
//

import XCTest
import CounterCore
import CounterTests
@testable import CounterStore

final class IncrementCounterFromCacheUseCaseTests: XCTestCase {

    func testInitDoesNotTriggerAnyCall() {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.messages, [])
    }
    
    func testIncrementFailsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()
        
        expect(sut, toCompleteWith: .failure(retrievalError)) {
            store.completionRetrieval(with: retrievalError)
        }
        
        XCTAssertEqual(store.messages, [.retrieve])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #filePath, line: UInt = #line
    ) -> (sut: LocalCounterIncrementer, store: CounterStoreSpy) {
        let store = CounterStoreSpy()
        let sut = LocalCounterIncrementer(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(
        _ sut: LocalCounterIncrementer,
        toCompleteWith expectedResult: Result<Counter, Error>,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        action()
        
        var receivedResult: Result<Counter, Error>?
        
        sut.increment("any id") { receivedResult = $0 }
        
        switch (receivedResult, expectedResult) {
        case let (.success(receivedImages), .success(expectedImages)):
            XCTAssertEqual(receivedImages, expectedImages, file: file, line: line)
            
        case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            
        default:
            XCTFail("Expected result \(expectedResult), got \(String(describing: receivedResult)) instead", file: file, line: line)
        }
    }
}
