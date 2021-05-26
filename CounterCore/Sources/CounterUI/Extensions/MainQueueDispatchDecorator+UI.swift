//
//  MainQueueDispatchDecorator+UI.swift
//  
//
//  Created by Thales Frigo on 22/05/21.
//

import Foundation
import CounterCore

extension MainQueueDispatchDecorator: CounterLoader where T == CounterLoader {
    
    public func load(completion: @escaping (CounterLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: CounterCreator where T == CounterCreator {
    
    public func create(_ request: CreateCounterRequest, completion: @escaping (CounterCreator.Result) -> Void) {
        decoratee.create(request) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: CounterIncrementer where T == CounterIncrementer {
    
    public func increment(_ id: Counter.ID, completion: @escaping (CounterIncrementer.Result) -> Void) {
        decoratee.increment(id) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: CounterDecrementer where T == CounterDecrementer {
    
    public func decrement(_ id: Counter.ID, completion: @escaping (CounterDecrementer.Result) -> Void) {
        decoratee.decrement(id) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: CounterEraser where T == CounterEraser {
    
    public func erase(_ ids: [Counter.ID], completion: @escaping (CounterEraser.Result) -> Void) {
        decoratee.erase(ids) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}
