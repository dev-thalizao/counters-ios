//
//  ShareItemPresenter.swift
//  
//
//  Created by Thales Frigo on 26/05/21.
//

import Foundation
import CounterCore

public struct ShareItemViewModel: Equatable {
    public let item: String
}

public struct ShareItemPresenter {
    
    public static func map(_ counter: Counter) -> ShareItemViewModel {
        return .init(item: "\(counter.count)x \(counter.title)")
    }
}
