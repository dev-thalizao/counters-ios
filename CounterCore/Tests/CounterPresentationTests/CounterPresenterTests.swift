//
//  CounterPresenterTests.swift
//  
//
//  Created by Thales Frigo on 19/05/21.
//

import XCTest
@testable import CounterPresentation

final class CounterPresenterTests: XCTestCase {
    
    func testPresenterTitle() {
        XCTAssertEqual(CounterPresenter.title, "Counters")
    }
}
