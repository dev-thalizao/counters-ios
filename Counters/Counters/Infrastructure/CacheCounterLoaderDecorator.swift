//
//  CacheCounterLoaderDecorator.swift
//  Counters
//
//  Created by Thales Frigo on 27/05/21.
//

import Foundation
import CounterCore

final class CacheCounterLoaderDecorator: CounterLoader {
    
    private let decoratee: CounterLoader
    private let cache: CounterCache
    
    init(decoratee: CounterLoader, cache: CounterCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    func load(completion: @escaping (CounterLoader.Result) -> Void) {
        decoratee.load { [cache] result in
            completion(result.flatMap { counters -> Result<[Counter], Error> in
                do {
                    try cache.save(counters)
                    return .success(counters)
                } catch {
                    return .failure(error)
                }
            })
        }
    }
}
