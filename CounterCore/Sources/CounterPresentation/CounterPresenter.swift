//
//  CounterPresenter.swift
//  
//
//  Created by Thales Frigo on 19/05/21.
//

import Foundation
import CounterCore

final class CounterPresenter {
    
    static let title = "Counters"
    
    static func map(_ counters: [Counter]) -> CountersViewModel {
        return CountersViewModel(
            counters: counters.map { counter in
                CounterViewModel(
                    count: counter.count.description,
                    title: counter.title
                )
            }
        )
    }
}
