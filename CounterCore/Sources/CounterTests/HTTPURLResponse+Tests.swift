//
//  HTTPURLResponse+Tests.swift
//  
//
//  Created by Thales Frigo on 27/05/21.
//

import Foundation

public extension HTTPURLResponse {
    
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
    
    class var OK: HTTPURLResponse {
        return .init(statusCode: 200)
    }
}
