//
//  CounterPresenter.swift
//  
//
//  Created by Thales Frigo on 21/05/21.
//

import Foundation
import CounterCore

public struct CounterViewModel: Hashable {
    public let count: String
    public let title: String
}

final class CounterPresenter {
    
    static func map(_ counter: Counter) -> CounterViewModel {
        return CounterViewModel(
            count: counter.count.description,
            title: counter.title
        )
    }
}
