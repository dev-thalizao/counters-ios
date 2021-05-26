//
//  MainQueueDispatchDecorator.swift
//  Counters
//
//  Created by Thales Frigo on 26/05/21.
//

import Foundation
import CounterCore

final class MainQueueDispatchDecorator<T> {
    
    private let decoratee: T
    
    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }
        
        completion()
    }
}

extension MainQueueDispatchDecorator: CounterLoader where T == CounterLoader {
    
    func load(completion: @escaping (CounterLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: CounterCreator where T == CounterCreator {
    
    func create(_ request: CreateCounterRequest, completion: @escaping (CounterCreator.Result) -> Void) {
        decoratee.create(request) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: CounterIncrementer where T == CounterIncrementer {
    
    func increment(_ id: Counter.ID, completion: @escaping (CounterIncrementer.Result) -> Void) {
        decoratee.increment(id) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: CounterDecrementer where T == CounterDecrementer {
    
    func decrement(_ id: Counter.ID, completion: @escaping (CounterDecrementer.Result) -> Void) {
        decoratee.decrement(id) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: CounterEraser where T == CounterEraser {
    
    func erase(_ ids: [Counter.ID], completion: @escaping (CounterEraser.Result) -> Void) {
        decoratee.erase(ids) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}
