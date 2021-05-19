//
//  File.swift
//  
//
//  Created by Thales Frigo on 19/05/21.
//

import Foundation
import CounterCore

extension Counter {
    
    static func any(id: String = "any id") -> Counter {
        return Counter(id: id, title: "any title", count: 0)
    }
    
    static func anyCollection(size: Int = 3) -> [Counter] {
        return (0..<3).map(String.init).map(Counter.any)
    }
}
