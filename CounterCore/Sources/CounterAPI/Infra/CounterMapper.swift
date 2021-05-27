//
//  RemoteCounter.swift
//  
//
//  Created by Thales Frigo on 27/05/21.
//

import Foundation
import CounterCore

final class CounterMapper {
    
    private init() {}
    
    struct RemoteCounter: Decodable {
        let id: String
        let title: String
        let count: Int
        
        var counter: Counter {
            return .init(id: id, title: title, count: count)
        }
    }
    
    enum Error: Swift.Error {
        case invalidData
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Counter]  {
        guard
            response.statusCode == 200,
            let remotes = try? JSONDecoder().decode([RemoteCounter].self, from: data)
        else {
            throw Error.invalidData
        }
        
        return remotes.map(\.counter)
    }
}
