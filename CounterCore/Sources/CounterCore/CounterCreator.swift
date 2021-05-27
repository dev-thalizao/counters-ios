//
//  CounterCreator.swift
//  
//
//  Created by Thales Frigo on 18/05/21.
//

import Foundation

public struct CreateCounterRequest {

    public let id: Counter.ID 
    public let title: String
    
    public init(id: Counter.ID, title: String) {
        self.id = id
        self.title = title
    }
}

public protocol CounterCreator {
    typealias Result = Swift.Result<Counter, Error>
    
    func create(_ request: CreateCounterRequest, completion: @escaping (Result) -> Void)
}
