//
//  InteractorLoadingView.swift
//  
//
//  Created by Thales Frigo on 19/05/21.
//

import Foundation

struct InteractorLoadingViewModel {
    let isLoading: Bool
}

protocol InteractorLoadingView {
    func display(_ viewModel: InteractorLoadingViewModel)
}
