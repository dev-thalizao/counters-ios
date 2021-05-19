//
//  CreateCounterFromCacheUseCaseTests.swift
//
//
//  Created by Thales Frigo on 19/05/21.
//

import XCTest
import CounterCore
import CounterTests
@testable import CounterStore

final class CreateCounterFromCacheUseCaseTests: XCTestCase {

    func testInitDoesNotTriggerAnyCall() {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.messages, [])
    }
    
    func testCreateFailsOnInsertionError() {
        let (sut, store) = makeSUT()
        let insertionError = anyNSError()
        
        expect(sut, toCompleteWith: .failure(insertionError)) {
            store.completeInsertion(with: insertionError)
        }
        
        XCTAssertEqual(store.messages, [.insert])
    }
    
    func testCreateSucceedsOnSuccessfulInsertion() {
        let (sut, store) = makeSUT()
        let counter = Counter(id: "expect-id", title: "expect-title", count: 0)
        
        expect(sut, toCompleteWith: .success(counter)) {
            store.completeInsertionSuccessfully()
        }
        
        XCTAssertEqual(store.messages, [.insert])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #filePath, line: UInt = #line
    ) -> (sut: LocalCounterCreator, store: CounterStoreSpy) {
        let store = CounterStoreSpy()
        let sut = LocalCounterCreator(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(
        _ sut: LocalCounterCreator,
        toCompleteWith expectedResult: Result<Counter, Error>,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        action()
        
        var receivedResult: Result<Counter, Error>?
        
        sut.create(.init(id: "expect-id", title: "expect-title")) { receivedResult = $0 }
        
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
