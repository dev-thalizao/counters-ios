//
//  File.swift
//  
//
//  Created by Thales Frigo on 27/05/21.
//

import Foundation
import CounterCore

enum CounterAPI {
    
    static let baseURL = URL(string: "http://0.0.0.0:3000/api")!
    
    case get
    case create(title: String)
    case increment(id: String)
    case decrement(id: String)
    case delete(id: String)
    
    func request() -> URLRequest {
        switch self {
        case .get:
            var components = URLComponents()
            components.scheme = Self.baseURL.scheme
            components.host = Self.baseURL.host
            components.path = "/v1/counter"
            
            return URLRequest(url: components.url!)
            
        case let .create(title):
            var components = URLComponents()
            components.scheme = Self.baseURL.scheme
            components.host = Self.baseURL.host
            components.path = "/v1/counter"
            
            var request = URLRequest(url: components.url!)
            request.httpMethod = "POST"
            request.httpBody = try! JSONSerialization.data(
                withJSONObject: ["title": title],
                options: []
            )
            
            return request
            
        case let .increment(id):
            var components = URLComponents()
            components.scheme = Self.baseURL.scheme
            components.host = Self.baseURL.host
            components.path = "/v1/counter/inc"
            
            var request = URLRequest(url: components.url!)
            request.httpMethod = "POST"
            request.httpBody = try! JSONSerialization.data(
                withJSONObject: ["id": id],
                options: []
            )
            
            return request
            
        case let .decrement(id):
            var components = URLComponents()
            components.scheme = Self.baseURL.scheme
            components.host = Self.baseURL.host
            components.path = "/v1/counter/dec"
            
            var request = URLRequest(url: components.url!)
            request.httpMethod = "POST"
            request.httpBody = try! JSONSerialization.data(
                withJSONObject: ["id": id],
                options: []
            )
            
            return request
            
        case let .delete(id):
            var components = URLComponents()
            components.scheme = Self.baseURL.scheme
            components.host = Self.baseURL.host
            components.path = "/v1/counter"
            
            var request = URLRequest(url: components.url!)
            request.httpMethod = "DELETE"
            request.httpBody = try! JSONSerialization.data(
                withJSONObject: ["id": id],
                options: []
            )
            
            return request
        }
    }
}
