//
//  CounterTests.swift
//
//
//  Created by Thales Frigo on 18/05/21.
//

import XCTest
@testable import CounterCore

final class CounterTests: XCTestCase {
    
    func testAddCounter() {
        var counter = Counter(id: "any", title: "any title", count: 0)
        counter.add()
        XCTAssertEqual(counter.count, 1)
    }
    
    func testRemoveCounter() {
        var counter = Counter(id: "any", title: "any title", count: 10)
        counter.remove()
        XCTAssertEqual(counter.count, 9)
    }
    
    func testAddingCounter() {
        let counter = Counter(id: "any", title: "any title", count: 0)
        let increased = counter.adding().adding()
        XCTAssertEqual(counter.count, 0)
        XCTAssertEqual(increased.count, 2)
    }
    
    func testRemovingCounter() {
        let counter = Counter(id: "any", title: "any title", count: 10)
        let decreased = counter.removing().removing()
        XCTAssertEqual(counter.count, 10)
        XCTAssertEqual(decreased.count, 8)
    }
}
