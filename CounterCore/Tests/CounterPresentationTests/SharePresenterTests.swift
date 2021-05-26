//
//  File.swift
//  
//
//  Created by Thales Frigo on 26/05/21.
//

import XCTest
import CounterCore
@testable import CounterPresentation

final class SharePresenterTests: XCTestCase {
    
    func testMapOfEmptyCountersCreateEmptyDescription() {
        let viewModel = SharePresenter.map([])
        XCTAssertTrue(viewModel.description.isEmpty)
    }
    
    func testMapOfNonEmptyCountersCreateNonEmptyDescription() {
        let counters = [
            Counter(id: "xvaf", title: "Cups of coffee", count: 5),
            Counter(id: "gfdg", title: "Records played", count: 10),
            Counter(id: "rtgc", title: "Apples eaten", count: 0),
        ]
        
        let viewModel = SharePresenter.map(counters)
        let expected = """
        5x Cups of coffee
        10x Records played
        0x Apples eaten
        """
        
        XCTAssertEqual(viewModel.description, expected)
    }
}
