//
//  File.swift
//  
//
//  Created by Thales Frigo on 19/05/21.
//

import Foundation
import CounterCore

extension Counter {
    
    static func any() -> Counter {
        return Counter(id: "any id", title: "any title", count: 0)
    }
}
