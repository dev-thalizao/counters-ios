//
//  FallbackCounterLoaderDecorator.swift
//  Counters
//
//  Created by Thales Frigo on 27/05/21.
//

import Foundation
import CounterCore

final class FallbackCounterLoaderDecorator: CounterLoader {
    
    private let decoratee: CounterLoader
    private let fallback: CounterLoader
    
    init(decoratee: CounterLoader, fallback: CounterLoader) {
        self.decoratee = decoratee
        self.fallback = fallback
    }
    
    func load(completion: @escaping (CounterLoader.Result) -> Void) {
        decoratee.load { [fallback] result in
            switch result {
            case let .success(counters):
                completion(.success(counters))
            case .failure:
                fallback.load(completion: completion)
            }
        }
    }
}
