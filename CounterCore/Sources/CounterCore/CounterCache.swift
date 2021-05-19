//
//  CounterCache.swift
//  
//
//  Created by Thales Frigo on 18/05/21.
//

import Foundation

public protocol CounterCache {
    func save(_ counters: [Counter]) throws
}
