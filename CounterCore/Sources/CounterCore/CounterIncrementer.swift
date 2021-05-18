//
//  CounterIncrementer.swift
//  
//
//  Created by Thales Frigo on 18/05/21.
//

import Foundation

public protocol CounterIncrementer {
    typealias Result = Swift.Result<Counter, Error>
    
    func increment(_ id: Counter.ID, completion: @escaping (Result) -> Void)
}
