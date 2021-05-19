//
//  CoreDataCounterStoreTests.swift
//  
//
//  Created by Thales Frigo on 19/05/21.
//

import XCTest
import CounterCore
import CounterTests
@testable import CounterStore

final class CoreDataCounterStoreTests: XCTestCase {
    
    func testRetrieveDeliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        expect(sut, toRetrieve: .success([]))
    }
    
    func testRetrieveDeliversFoundValuesOnFilledCache() {
        let sut = makeSUT()
        let counters = Counter.anyCollection();
        
        insert(counters, to: sut)
        
        expect(sut, toRetrieve: .success(counters))
    }
    
    func testInsertDeliversNoErrorOnEmptyCache() {
        let sut = makeSUT()
        XCTAssertNil(insert([.any()], to: sut))
    }
    
    func testInsertDeliversNoErrorOnFilledCache() {
        let sut = makeSUT()
        XCTAssertNil(insert([.any(id: "1")], to: sut))
        expect(sut, toRetrieve: .success([.any(id: "1")]))
        
        XCTAssertNil(insert([.any(id: "2")], to: sut))
        expect(sut, toRetrieve: .success([.any(id: "1"), .any(id: "2")]))
    }
    
    func testCounterDeliversNotFoundErrorOnEmptyCache() {
        let sut = makeSUT()
        XCTAssertThrowsError(try sut.counter(with: "anyid")) { error in
            XCTAssertEqual(error as NSError, ManagedCounter.NotFoundError() as NSError)
        }
    }
    
    func testCounterDeliversCounterOnFilledCache() {
        let sut = makeSUT()
        insert([.any(id: "cd-id")], to: sut)
        XCTAssertNoThrow(try sut.counter(with: "cd-id"))
    }
    
    func testIncreaseKeepOnlyOneInstanceOnCache() throws {
        let sut = makeSUT()
        insert([.init(id: "increase-id", title: "Counter to increase", count: 0)], to: sut)
        
        var counter = try sut.counter(with: "increase-id")
        counter.add()
        counter.add()
        counter.add()
        
        insert([counter], to: sut)
        
        expect(sut, toRetrieve: .success([.init(id: "increase-id", title: "Counter to increase", count: 3)]))
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> CounterStore {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataCounterStore(storeURL: storeURL)
        trackForMemoryLeaks(sut)
        return sut
    }
    
    @discardableResult
    private func insert(_ counters: [Counter], to sut: CounterStore) -> Error? {
        do {
            try sut.insert(counters)
            return nil
        } catch {
            return error
        }
    }
    
    private func expect(_ sut: CounterStore, toRetrieve expectedResult: Result<[Counter], Error>, file: StaticString = #filePath, line: UInt = #line) {
        let retrievedResult = Result { try sut.retrieve() }
        
        switch (expectedResult, retrievedResult) {
        case let (.success(expected), .success(retrieved)):
            XCTAssertEqual(Set(retrieved), Set(expected), file: file, line: line)
        default:
            XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
        }
    }
}
