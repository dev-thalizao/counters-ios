//
//  CounterPresenterTests.swift
//  
//
//  Created by Thales Frigo on 19/05/21.
//

import XCTest
import CounterCore
@testable import CounterPresentation

final class CounterPresenterTests: XCTestCase {
    
    func testPresenterTitle() {
        XCTAssertEqual(CounterPresenter.title, "Counters")
    }
    
    func testMapCreatesViewModels() {
        let counters = [
            Counter(id: "xvaf", title: "Cups of coffee", count: 5),
            Counter(id: "gfdg", title: "Records played", count: 10),
            Counter(id: "rtgc", title: "Apples eaten", count: 0),
        ]
        
        let viewModel = CounterPresenter.map(counters)
        
        XCTAssertEqual(viewModel.summary, "3 items · Counted 15 times")
        XCTAssertEqual(viewModel.counters, [
            CounterViewModel(count: "5", title: "Cups of coffee"),
            CounterViewModel(count: "10", title: "Records played"),
            CounterViewModel(count: "0", title: "Apples eaten")
        ])
    }
    
    func testMapOfEmptyViewModelsCreateEmptySummary() {
        let viewModel = CounterPresenter.map([])
        XCTAssertTrue(viewModel.summary.isEmpty)
    }
    
    func testMapOfOneViewModelsCreateSingleSummary() {
        let viewModel = CounterPresenter.map([
            Counter(id: "asdf", title: "Apples eaten", count: 1)
        ])
        XCTAssertEqual(viewModel.summary, "1 item · Counted 1 time")
    }
    
    func testMapOfOneViewModelsCreateMiscSummary() {
        let viewModel = CounterPresenter.map([
            Counter(id: "asdf", title: "Apples eaten", count: 2)
        ])
        XCTAssertEqual(viewModel.summary, "1 item · Counted 2 times")
    }
}
