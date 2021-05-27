//
//  InteractorErrorView.swift
//  
//
//  Created by Thales Frigo on 19/05/21.
//

import Foundation

public struct InteractorErrorViewModel {
    
    public let reason: String?
    
    static var noError: InteractorErrorViewModel {
        return .init(reason: nil)
    }
    
    static func error(_ error: Error) -> InteractorErrorViewModel {
        return .init(reason: error.localizedDescription)
    }
}

public protocol InteractorErrorView {
    func display(viewModel: InteractorErrorViewModel)
}
