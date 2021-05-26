//
//  MainQueueDispatchDecorator.swift
//  
//
//  Created by Thales Frigo on 20/05/21.
//

import Foundation

public final class MainQueueDispatchDecorator<T> {
    
    let decoratee: T
    
    public init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }
        
        completion()
    }
}