//
//  SharedTestHelpers.swift
//
//
//  Created by Thales Frigo on 19/05/21.
//

import Foundation

public func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

public func anyURL() -> URL {
    return URL(string: "http://valid-url.com")!
}
