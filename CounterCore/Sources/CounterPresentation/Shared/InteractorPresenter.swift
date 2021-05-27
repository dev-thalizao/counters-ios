//
//  InteractorPresenter.swift
//  
//
//  Created by Thales Frigo on 19/05/21.
//

import Foundation

public protocol InteractorResourceView {
    associatedtype InteractorResourceViewModel
    
    func display(viewModel: InteractorResourceViewModel)
}

public final class InteractorPresenter<Resource, View: InteractorResourceView> {
    public typealias Mapper = (Resource) throws -> View.InteractorResourceViewModel
    
    private let resourceView: View
    private let loadingView: InteractorLoadingView
    private let errorView: InteractorErrorView
    private let mapper: Mapper
    
    public init(resourceView: View, loadingView: InteractorLoadingView, errorView: InteractorErrorView, mapper: @escaping Mapper) {
        self.resourceView = resourceView
        self.loadingView = loadingView
        self.errorView = errorView
        self.mapper = mapper
    }
    
    public init(resourceView: View, loadingView: InteractorLoadingView, errorView: InteractorErrorView) where Resource == View.InteractorResourceViewModel {
        self.resourceView = resourceView
        self.loadingView = loadingView
        self.errorView = errorView
        self.mapper = { $0 }
    }
    
    func didStartLoading() {
        loadingView.display(viewModel: .init(isLoading: true))
        errorView.display(viewModel: .noError)
    }
    
    func didFinishLoading(with resource: Resource) {
        do {
            loadingView.display(viewModel: .init(isLoading: false))
            resourceView.display(viewModel: try mapper(resource))
        } catch {
            didFinishLoading(with: error)
        }
    }
    
    func didFinishLoading(with error: Error) {
        loadingView.display(viewModel: .init(isLoading: false))
        errorView.display(viewModel: .error(error))
    }
}
