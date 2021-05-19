//
//  LocalCounterLoader.swift
//
//
//  Created by Thales Frigo on 18/05/21.
//

import Foundation
import CounterCore

public final class LocalCounterLoader {
    
    private let store: CounterStore
    
    public init(store: CounterStore) {
        self.store = store
    }
}

extension LocalCounterLoader: CounterLoader {
    
    public func load(completion: @escaping (CounterLoader.Result) -> Void) {
        completion(Result {
            try store.retrieve() ?? []
        })
    }
}

extension LocalCounterLoader: CounterCache {
    
    public func save(_ counters: [Counter]) throws {
        try store.insert(counters)
    }
}
