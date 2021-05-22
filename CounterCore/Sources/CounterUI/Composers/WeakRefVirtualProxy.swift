//
//  WeakRefVirtualProxy.swift
//  
//
//  Created by Thales Frigo on 20/05/21.
//

import Foundation

final class WeakRefVirtualProxy<T: AnyObject> {
    
    private(set) weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}
