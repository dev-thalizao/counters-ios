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
    
    func testMapCreatesViewModels() {
        let counters = [
            Counter(id: "xvaf", title: "Cups of coffee", count: 5),
            Counter(id: "gfdg", title: "Records played", count: 10),
            Counter(id: "rtgc", title: "Apples eaten", count: 0),
        ]
        
        let viewModels = counters.map(CounterPresenter.map)
        
        XCTAssertEqual(viewModels, [
            CounterViewModel(count: "5", title: "Cups of coffee"),
            CounterViewModel(count: "10", title: "Records played"),
            CounterViewModel(count: "0", title: "Apples eaten")
        ])
    }
}
