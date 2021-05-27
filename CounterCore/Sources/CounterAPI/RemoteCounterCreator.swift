//
//  RemoteCounterCreator.swift
//  
//
//  Created by Thales Frigo on 27/05/21.
//

import Foundation
import CounterCore

public final class RemoteCounterCreator: CounterCreator {
    
    private let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public struct CreatorError: Error {}
    
    public func create(_ request: CreateCounterRequest, completion: @escaping (CounterCreator.Result) -> Void) {
        let endpoint = CounterAPI.create(title: request.title).request()
        client.execute(endpoint) { (result) in
            completion(result.flatMap({ (data, response) -> Result<Counter, Error> in
                do {
                    let counters = try CounterMapper.map(data, from: response)
                    
                    guard
                        let counter = counters.first(where: { $0.title == request.title })
                    else {
                        throw CreatorError()
                    }
                    
                    return .success(counter)
                    
                } catch {
                    return .failure(error)
                }
            }))
        }
    }
}
