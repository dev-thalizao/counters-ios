//
//  SharePresenter.swift
//  
//
//  Created by Thales Frigo on 26/05/21.
//

import Foundation
import CounterCore

public struct ShareViewModel: Equatable {
    public let items: [ShareItemViewModel]
    
    public var description: String {
        return items.map(\.item).joined(separator: "\n")
    }
}

public struct SharePresenter {
    
    public static func map(_ counters: [Counter]) -> ShareViewModel {
        return .init(items: counters.map(ShareItemPresenter.map))
    }
}
