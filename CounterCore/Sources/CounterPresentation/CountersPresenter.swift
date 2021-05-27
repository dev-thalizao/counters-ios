//
//  CountersPresenter.swift
//  
//
//  Created by Thales Frigo on 19/05/21.
//

import Foundation
import CounterCore

public struct CountersViewModel: Hashable {
    public let summary: String
}

extension CountersViewModel {
    
    public static var empty: CountersViewModel {
        return .init(summary: "")
    }
}

public final class CountersPresenter {
    
    private init() {}
    
    public static let title = "Counters"
    
    public static func map(_ counters: [Counter]) -> CountersViewModel {
        guard !counters.isEmpty else { return .empty }
        
        var summary = [String]()
        
        summary.append("\(counters.count)")
        counters.count > 1
            ? summary.append("items")
            : summary.append("item")

        let total = counters
            .map(\.count)
            .compactMap(Int.init)
            .reduce(0, +)
        
        summary.append("· Counted \(total)")
        
        total == 1
            ? summary.append("time")
            : summary.append("times")
            
        return CountersViewModel(summary: summary.joined(separator: " "))
    }
}
