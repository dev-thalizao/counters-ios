//
//  CounterCreator.swift
//  
//
//  Created by Thales Frigo on 18/05/21.
//

import Foundation

public protocol CounterCreator {
    typealias Result = Swift.Result<Counter, Error>
    
    func create(_ name: String, completion: @escaping (Result) -> Void)
}
