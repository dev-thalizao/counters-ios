//
//  CounterLoader.swift
//  
//
//  Created by Thales Frigo on 18/05/21.
//

import Foundation

public protocol CounterLoader {
    typealias Result = Swift.Result<[Counter], Error>
    
    func load(completion: @escaping (Result) -> Void)
}
