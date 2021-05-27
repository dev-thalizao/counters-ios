//
//  HTTPClient.swift
//  
//
//  Created by Thales Frigo on 18/05/21.
//

import Foundation

public protocol HTTPClientTask {
    func cancel()
}

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    @discardableResult
    func execute(_ request: URLRequest, completion: @escaping (Result) -> Void) -> HTTPClientTask
}
