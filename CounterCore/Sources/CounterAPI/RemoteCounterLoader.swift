//
//  RemoteCounterLoader.swift
//  
//
//  Created by Thales Frigo on 27/05/21.
//

import Foundation
import CounterCore

public final class RemoteCounterLoader: CounterLoader {
    
    private let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public func load(completion: @escaping (CounterLoader.Result) -> Void) {
        let request = CounterAPI.get.request()
        client.execute(request) { result in
            completion(result.flatMap({ (data, response) -> Result<[Counter], Error> in
                do {
                    return .success(try CounterMapper.map(data, from: response))
                } catch {
                    return .failure(error)
                }
            }))
        }
    }
}
