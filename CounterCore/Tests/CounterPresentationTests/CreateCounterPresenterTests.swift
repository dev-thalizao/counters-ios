//
//  CreateCounterPresenterTests.swift
//  
//
//  Created by Thales Frigo on 26/05/21.
//

import XCTest
import CounterCore
@testable import CounterPresentation

final class CreateCounterPresenterTests: XCTestCase {
    
    func testPresenterTitle() {
        XCTAssertEqual(CreateCounterPresenter.title, "Create a counter")
    }
}
