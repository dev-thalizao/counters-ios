//
//  LocalCounterEraser.swift
//  
//
//  Created by Thales Frigo on 26/05/21.
//

import Foundation
import CounterCore

public final class LocalCounterEraser: CounterEraser {
    
    private let store: CounterStore
    
    public init(store: CounterStore) {
        self.store = store
    }
    
    public func erase(_ ids: [Counter.ID], completion: @escaping (CounterEraser.Result) -> Void) {
        completion(Result {
            try ids.forEach(store.delete(with:))
        })
    }
}
