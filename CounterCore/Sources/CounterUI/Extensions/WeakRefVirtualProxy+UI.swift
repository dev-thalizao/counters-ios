//
//  WeakRefVirtualProxy+UI.swift
//  
//
//  Created by Thales Frigo on 22/05/21.
//

import Foundation
import CounterPresentation

extension WeakRefVirtualProxy: InteractorLoadingView where T: InteractorLoadingView {
    
    func display(viewModel: InteractorLoadingViewModel) {
        object?.display(viewModel: viewModel)
    }
}

extension WeakRefVirtualProxy: InteractorErrorView where T: InteractorErrorView {
    
    func display(viewModel: InteractorErrorViewModel) {
        object?.display(viewModel: viewModel)
    }
}

extension WeakRefVirtualProxy: InteractorResourceView where T: InteractorResourceView, T.InteractorResourceViewModel == CounterViewModel {
    
    func display(viewModel: CounterViewModel) {
        object?.display(viewModel: viewModel)
    }
}
