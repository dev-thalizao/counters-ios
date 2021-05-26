//
//  ShareItemPresenterTests.swift
//  
//
//  Created by Thales Frigo on 26/05/21.
//

import XCTest
import CounterCore
@testable import CounterPresentation

final class ShareItemPresenterTests: XCTestCase {
    
    func testMapCreatesViewModels() {
        let counters = [
            Counter(id: "xvaf", title: "Cups of coffee", count: 5),
            Counter(id: "gfdg", title: "Records played", count: 10),
            Counter(id: "rtgc", title: "Apples eaten", count: 0),
        ]
        
        let viewModels = counters.map(ShareItemPresenter.map)
        
        XCTAssertEqual(viewModels, [
            ShareItemViewModel(item: "5x Cups of coffee"),
            ShareItemViewModel(item: "10x Records played"),
            ShareItemViewModel(item: "0x Apples eaten")
        ])
    }
}
