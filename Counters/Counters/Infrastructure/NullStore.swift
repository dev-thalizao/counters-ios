//
//  NullStore.swift
//  Counters
//
//  Created by Thales Frigo on 26/05/21.
//

import Foundation
import CounterCore
import CounterStore

final class NullStore: CounterStore {
    
    func retrieve() throws -> [Counter] {
        return []
    }
    
    func insert(_ counters: [Counter]) throws {}
    
    struct NotFoundError: Error {}
    
    func counter(with id: Counter.ID) throws -> Counter {
        throw NotFoundError()
    }
    
    func delete(with id: Counter.ID) throws {}
}
