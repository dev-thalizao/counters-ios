//
//  NSManagedObjectModel+Extensions.swift
//  
//
//  Created by Thales Frigo on 19/05/21.
//

import CoreData

extension NSManagedObjectModel {
    
    static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
        return bundle
            .url(forResource: name, withExtension: "momd")
            .flatMap { NSManagedObjectModel(contentsOf: $0) }
    }
}
