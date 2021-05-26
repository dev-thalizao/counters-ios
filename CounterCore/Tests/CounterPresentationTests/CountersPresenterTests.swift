//
//  CountersPresenterTests.swift
//  
//
//  Created by Thales Frigo on 19/05/21.
//

import XCTest
import CounterCore
@testable import CounterPresentation

final class CountersPresenterTests: XCTestCase {
    
    func testPresenterTitle() {
        XCTAssertEqual(CountersPresenter.title, "Counters")
    }
    
    func testMapCreatesViewModels() {
        let counters = [
            Counter(id: "xvaf", title: "Cups of coffee", count: 5),
            Counter(id: "gfdg", title: "Records played", count: 10),
            Counter(id: "rtgc", title: "Apples eaten", count: 0),
        ]
        
        let viewModel = CountersPresenter.map(counters)
        
        XCTAssertEqual(viewModel.summary, "3 items · Counted 15 times")
    }
    
    func testMapOfEmptyViewModelsCreateEmptySummary() {
        let viewModel = CountersPresenter.map([])
        XCTAssertTrue(viewModel.summary.isEmpty)
    }
    
    func testMapOfOneViewModelsCreateSingleSummary() {
        let viewModel = CountersPresenter.map([
            Counter(id: "asdf", title: "Apples eaten", count: 1)
        ])
        XCTAssertEqual(viewModel.summary, "1 item · Counted 1 time")
    }
    
    func testMapOfOneViewModelsCreateMiscSummary() {
        let viewModel = CountersPresenter.map([
            Counter(id: "asdf", title: "Apples eaten", count: 2)
        ])
        XCTAssertEqual(viewModel.summary, "1 item · Counted 2 times")
    }
}
