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

    static var allTests = [
        ("testAddCounter", testAddCounter),
    ]
}
