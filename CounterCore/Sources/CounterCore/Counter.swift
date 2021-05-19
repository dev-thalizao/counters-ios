//
//  Counter.swift
//  
//
//  Created by Thales Frigo on 18/05/21.
//

import Foundation

public struct Counter: Identifiable, Hashable {
    
    public let id: String
    public let title: String
    public private(set) var count: Int
    
    public init(id: String, title: String, count: Int) {
        self.id = id
        self.title = title
        self.count = count
    }
    
    public mutating func add() {
        self.count += 1
    }
    
    public func adding() -> Counter {
        var mutable = self
        mutable.add()
        return mutable
    }
    
    public mutating func remove() {
        self.count -= 1
    }
    
    public func removing() -> Counter {
        var mutable = self
        mutable.remove()
        return mutable
    }
}
