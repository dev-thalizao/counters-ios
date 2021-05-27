//
//  RemoteCounterDecrementer.swift
//
//
//  Created by Thales Frigo on 27/05/21.
//

import Foundation
import CounterCore

public final class RemoteCounterDecrementer: CounterDecrementer {
    
    private let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public struct DecrementerError: Error {}
    
    public func decrement(_ id: Counter.ID, completion: @escaping (CounterDecrementer.Result) -> Void) {
        let endpoint = CounterAPI.decrement(id: id).request()
        client.execute(endpoint) { (result) in
            completion(result.flatMap({ (data, response) -> Result<Counter, Error> in
                do {
                    guard let counter = try CounterMapper
                        .map(data, from: response)
                        .first(where: { $0.id == id })
                    else {
                        throw DecrementerError()
                    }
                    
                    return .success(counter)
                    
                } catch {
                    return .failure(error)
                }
            }))
        }
    }
}
