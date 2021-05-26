//
//  InteractorErrorView.swift
//  
//
//  Created by Thales Frigo on 19/05/21.
//

import Foundation

public struct InteractorErrorViewModel {
    public let reason: String?
}

public protocol InteractorErrorView {
    func display(viewModel: InteractorErrorViewModel)
}
