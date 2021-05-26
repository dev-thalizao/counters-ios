//
//  WeakRefVirtualProxy.swift
//  Counters
//
//  Created by Thales Frigo on 26/05/21.
//

import Foundation
import CounterPresentation

final class WeakRefVirtualProxy<T: AnyObject> {
    
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

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
