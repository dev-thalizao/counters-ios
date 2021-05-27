//
//  RemoteCounterEraser.swift
//  
//
//  Created by Thales Frigo on 27/05/21.
//

import Foundation
import CounterCore

public final class RemoteCounterEraser: CounterEraser {
    
    private let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public struct EraserError: Error {}
    
    public func erase(_ ids: [Counter.ID], completion: @escaping (CounterEraser.Result) -> Void) {
        let group = DispatchGroup()
        var results = [CounterEraser.Result]()
        
        ids.forEach { id in
            group.enter()
            let endpoint = CounterAPI.delete(id: id).request()
            client.execute(endpoint) { result in
                switch result {
                case let .success((data, response)):
                    do {
                        guard try CounterMapper
                            .map(data, from: response)
                            .first(where: { $0.id == id }) == nil
                        else {
                            throw EraserError()
                        }
                        
                        results.append(.success(()))
                    } catch {
                        results.append(.failure(error))
                    }
                    
                case let .failure(error):
                    results.append(.failure(error))
                }
                group.leave()
            }
        }
        
        group.wait()
        
        completion(results.reduce(.success(())) { (accumulator, next) -> Result<Void, Error> in
            switch next {
            case .failure:
                return next
            case .success:
                return accumulator
            }
        })
    }
}
