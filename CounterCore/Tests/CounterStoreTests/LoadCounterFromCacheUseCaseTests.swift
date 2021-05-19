//
//  LoadCounterFromCacheUseCaseTests.swift
//
//
//  Created by Thales Frigo on 19/05/21.
//

import XCTest
import CounterCore
import CounterTests
@testable import CounterStore

final class LoadCounterFromCacheUseCaseTests: XCTestCase {
    
    func testInitDoesNotTriggerAnyCall() {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.messages, [])
    }
    
    func testLoadFailsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()
        
        expect(sut, toCompleteWith: .failure(retrievalError)) {
            store.completionRetrieval(with: retrievalError)
        }
        
        XCTAssertEqual(store.messages, [.retrieve])
    }
    
    func testLoadDeliversNoCounterOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: .success([])) {
            store.completionRetrievalWithEmptyCache()
        }
        
        XCTAssertEqual(store.messages, [.retrieve])
    }
    
    func testLoadDeliversCachedCountersOnValidCache() {
        let (sut, store) = makeSUT()
        let counters = [
            Counter(id: "any id", title: "any title", count: 0)
        ]
        
        expect(sut, toCompleteWith: .success(counters)) {
            store.completionRetrieval(with: counters)
        }
        
        XCTAssertEqual(store.messages, [.retrieve])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #filePath, line: UInt = #line
    ) -> (sut: LocalCounterLoader, store: CounterStoreSpy) {
        let store = CounterStoreSpy()
        let sut = LocalCounterLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(
        _ sut: LocalCounterLoader,
        toCompleteWith expectedResult: Result<[Counter], Error>,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        action()
        
        var receivedResult: Result<[Counter], Error>?
        
        sut.load { receivedResult = $0 }
        
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
