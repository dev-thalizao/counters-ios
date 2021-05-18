//
//  CounterDecrementer.swift
//  
//
//  Created by Thales Frigo on 18/05/21.
//

import Foundation

public protocol CounterDecrementer {
    typealias Result = Swift.Result<Counter, Error>
    
    func decrement(_ id: Counter.ID, completion: @escaping (Result) -> Void)
}
