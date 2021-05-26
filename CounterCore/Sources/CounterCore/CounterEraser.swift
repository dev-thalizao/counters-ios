//
//  CounterEraser.swift
//  
//
//  Created by Thales Frigo on 26/05/21.
//

import Foundation

public protocol CounterEraser {
    typealias Result = Swift.Result<Void, Error>
    
    func erase(_ ids: [Counter.ID], completion: @escaping (Result) -> Void)
}
