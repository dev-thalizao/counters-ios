//
//  LocalCounterIncrementer.swift
//  
//
//  Created by Thales Frigo on 19/05/21.
//

import Foundation
import CounterCore

public final class LocalCounterIncrementer: CounterIncrementer {
    
    private let store: CounterStore
    
    public init(store: CounterStore) {
        self.store = store
    }
    
    public func increment(_ id: Counter.ID, completion: @escaping (CounterIncrementer.Result) -> Void) {
        fatalError("Not implemented")
    }
}
