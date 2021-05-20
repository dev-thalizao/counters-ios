//
//  CounterViewModel.swift
//  
//
//  Created by Thales Frigo on 19/05/21.
//

import Foundation

struct CountersViewModel: Equatable {
    
    let counters: [CounterViewModel]
    
    var summary: String {
        guard !counters.isEmpty else { return "" }
        
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
        
        total > 1
            ? summary.append("times")
            : summary.append("time")
        
        return summary.joined(separator: " ")
    }
}

struct CounterViewModel: Equatable {
    let count: String
    let title: String
}
