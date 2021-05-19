//
//  LocalCounterCreator.swift
//  
//
//  Created by Thales Frigo on 19/05/21.
//

import Foundation
import CounterCore

public final class LocalCounterCreator: CounterCreator {
    
    private let store: CounterStore
    
    public init(store: CounterStore) {
        self.store = store
    }
    
    public func create(_ request: CreateCounterRequest, completion: @escaping (CounterCreator.Result) -> Void) {
        completion(Result {
            let counter = Counter(id: request.id, title: request.title, count: 0)
            try store.insert([counter])
            return counter
        })
    }
}
