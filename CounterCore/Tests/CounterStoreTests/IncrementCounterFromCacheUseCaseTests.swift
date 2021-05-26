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
    
    func testIncrementFailsOnCounterError() {
        let (sut, store) = makeSUT()
        let counterError = anyNSError()
        
        expect(sut, toCompleteWith: .failure(counterError)) {
            store.completeCounter(with: counterError)
        }
        
        XCTAssertEqual(store.messages, [.counter])
    }
    
    func testIncrementFailsOnInsertionError() {
        let (sut, store) = makeSUT()
        let insertionError = anyNSError()
        
        expect(sut, toCompleteWith: .failure(insertionError)) {
            store.completeCounter(with: .any())
            store.completeInsertion(with: insertionError)
        }
        
        XCTAssertEqual(store.messages, [.counter, .insert])
    }
    
    func testIncrementSucceedsOnSuccessfulInsertion() {
        let (sut, store) = makeSUT()
        let counter = Counter.any()
        
        expect(sut, toCompleteWith: .success(counter.adding())) {
            store.completeCounter(with: counter)
            store.completeInsertionSuccessfully()
        }
        
        XCTAssertEqual(store.messages, [.counter, .insert])
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
        case let (.success(received), .success(expected)):
            XCTAssertEqual(received, expected, file: file, line: line)
            
        case let (.failure(received as NSError), .failure(expected as NSError)):
            XCTAssertEqual(received, expected, file: file, line: line)
            
        default:
            XCTFail("Expected result \(expectedResult), got \(String(describing: receivedResult)) instead", file: file, line: line)
        }
    }
}
