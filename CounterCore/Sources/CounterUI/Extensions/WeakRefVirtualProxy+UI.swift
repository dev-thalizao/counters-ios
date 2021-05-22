//
//  WeakRefVirtualProxy+UI.swift
//  
//
//  Created by Thales Frigo on 22/05/21.
//

import Foundation
import CounterPresentation

extension WeakRefVirtualProxy: InteractorLoadingView where T: InteractorLoadingView {
    
    func display(_ viewModel: InteractorLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: InteractorErrorView where T: InteractorErrorView {
    
    func display(_ viewModel: InteractorErrorViewModel) {
        object?.display(viewModel)
    }
}
