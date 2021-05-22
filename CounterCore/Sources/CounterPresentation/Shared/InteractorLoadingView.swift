//
//  InteractorLoadingView.swift
//  
//
//  Created by Thales Frigo on 19/05/21.
//

import Foundation

public struct InteractorLoadingViewModel {
    public let isLoading: Bool
}

public protocol InteractorLoadingView {
    func display(_ viewModel: InteractorLoadingViewModel)
}
