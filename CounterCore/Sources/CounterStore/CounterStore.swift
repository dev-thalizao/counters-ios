//
//  CounterStore.swift
//  
//
//  Created by Thales Frigo on 19/05/21.
//

import Foundation
import CounterCore

public protocol CounterStore {
    func retrieve() throws -> [Counter]?
    func insert(_ counters: [Counter]) throws
}
