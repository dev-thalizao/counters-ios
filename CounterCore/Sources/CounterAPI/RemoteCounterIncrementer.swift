//
//  RemoteCounterIncrementer.swift
//  
//
//  Created by Thales Frigo on 27/05/21.
//

import Foundation
import CounterCore

public final class RemoteCounterIncrementer: CounterIncrementer {
    
    private let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public struct CounterIncrementerError: Error {}
    
    public func increment(_ id: Counter.ID, completion: @escaping (CounterIncrementer.Result) -> Void) {
        let endpoint = CounterAPI.increment(id: id).request()
        client.execute(endpoint) { (result) in
            completion(result.flatMap({ (data, response) -> Result<Counter, Error> in
                do {
                    guard let counter = try CounterMapper
                        .map(data, from: response)
                        .first(where: { $0.id == id })
                    else {
                        throw CounterIncrementerError()
                    }
                    
                    return .success(counter)
                    
                } catch {
                    return .failure(error)
                }
            }))
        }
    }
}
