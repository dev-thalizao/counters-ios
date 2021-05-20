//
//  InteractorPresenter.swift
//  
//
//  Created by Thales Frigo on 19/05/21.
//

import Foundation

protocol InteractorResourceView {
    associatedtype InteractorResourceViewModel
    
    func display(viewModel: InteractorResourceViewModel)
}

final class InteractorPresenter<Resource, View: InteractorResourceView> {
    typealias Mapper = (Resource) throws -> View.InteractorResourceViewModel
    
    private let resourceView: View
    private let loadingView: InteractorLoadingView
    private let errorView: InteractorErrorView
    private let mapper: Mapper
    
    init(resourceView: View, loadingView: InteractorLoadingView, errorView: InteractorErrorView, mapper: @escaping Mapper) {
        self.resourceView = resourceView
        self.loadingView = loadingView
        self.errorView = errorView
        self.mapper = mapper
    }
    
    func didStartLoading() {
        loadingView.display(.init(isLoading: true))
        errorView.display(.init(reason: nil))
    }
    
    func didFinishLoading(with resource: Resource) {
        do {
            loadingView.display(.init(isLoading: false))
            resourceView.display(viewModel: try mapper(resource))
        } catch {
            didFinishLoading(with: error)
        }
    }
    
    func didFinishLoading(with error: Error) {
        loadingView.display(.init(isLoading: false))
        errorView.display(.init(reason: error.localizedDescription))
    }
}
