//
//  DecrementCounterFromCacheUseCaseTests.swift
//
//
//  Created by Thales Frigo on 19/05/21.
//

import XCTest
import CounterCore
import CounterTests
@testable import CounterStore

final class DecrementCounterFromCacheUseCaseTests: XCTestCase {

    func testInitDoesNotTriggerAnyCall() {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.messages, [])
    }
    
    func testDecrementFailsOnCounterError() {
        let (sut, store) = makeSUT()
        let counterError = anyNSError()
        
        expect(sut, toCompleteWith: .failure(counterError)) {
            store.completeCounter(with: counterError)
        }
        
        XCTAssertEqual(store.messages, [.counter])
    }
    
    func testDecrementFailsOnInsertionError() {
        let (sut, store) = makeSUT()
        let insertionError = anyNSError()
        
        expect(sut, toCompleteWith: .failure(insertionError)) {
            store.completeCounter(with: .any())
            store.completeInsertion(with: insertionError)
        }
        
        XCTAssertEqual(store.messages, [.counter, .insert])
    }
    
    func testDecrementSucceedsOnSuccessfulInsertion() {
        let (sut, store) = makeSUT()
        let counter = Counter.any().adding().adding()
        
        expect(sut, toCompleteWith: .success(counter.removing())) {
            store.completeCounter(with: counter)
            store.completeInsertionSuccessfully()
        }
        
        XCTAssertEqual(store.messages, [.counter, .insert])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #filePath, line: UInt = #line
    ) -> (sut: LocalCounterDecrementer, store: CounterStoreSpy) {
        let store = CounterStoreSpy()
        let sut = LocalCounterDecrementer(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(
        _ sut: LocalCounterDecrementer,
        toCompleteWith expectedResult: Result<Counter, Error>,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        action()
        
        var receivedResult: Result<Counter, Error>?
        
        sut.decrement("any id") { receivedResult = $0 }
        
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
