//
//  LocalCounterDecrementer.swift
//
//
//  Created by Thales Frigo on 19/05/21.
//

import Foundation
import CounterCore

public final class LocalCounterDecrementer: CounterDecrementer {
    
    private let store: CounterStore
    
    public init(store: CounterStore) {
        self.store = store
    }
    public func decrement(_ id: Counter.ID, completion: @escaping (CounterDecrementer.Result) -> Void) {
        completion(Result {
            var counter = try store.counter(with: id)
            counter.remove()
            
            try store.insert([counter])
            return counter
        })
    }
}
