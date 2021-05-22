//
//  MainQueueDispatchDecorator+UI.swift
//  
//
//  Created by Thales Frigo on 22/05/21.
//

import Foundation
import CounterCore

extension MainQueueDispatchDecorator: CounterLoader where T == CounterLoader {
    
    func load(completion: @escaping (CounterLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}
