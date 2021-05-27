//
//  DeleteCounterFromCacheUseCaseTests.swift
//  
//
//  Created by Thales Frigo on 26/05/21.
//

import XCTest
import CounterCore
import CounterTests
@testable import CounterStore

final class DeleteCounterFromCacheUseCaseTests: XCTestCase {

    func testInitDoesNotTriggerAnyCall() {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.messages, [])
    }
    
    func testDeleteFailsOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        expect(sut, toCompleteWith: .failure(deletionError)) {
            store.completeDeletion(with: deletionError)
        }
        
        XCTAssertEqual(store.messages, [.delete])
    }
    
    func testDeleteSucceedsOnSuccessfulDeletion() {
        let (sut, store) = makeSUT()

        expect(sut, toCompleteWith: .success(())) {
            store.completeDeletionSuccessfully()
        }
        
        XCTAssertEqual(store.messages, [.delete])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #filePath, line: UInt = #line
    ) -> (sut: LocalCounterEraser, store: CounterStoreSpy) {
        let store = CounterStoreSpy()
        let sut = LocalCounterEraser(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(
        _ sut: LocalCounterEraser,
        toCompleteWith expectedResult: Result<Void, Error>,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        action()
        
        var receivedResult: Result<Void, Error>?
        
        sut.erase(["expect-id"]) { receivedResult = $0 }
        
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
