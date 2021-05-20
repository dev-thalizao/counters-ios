//
//  InteractorLoaderPresentationAdapter.swift
//  
//
//  Created by Thales Frigo on 19/05/21.
//

import Foundation

final class InteractorLoaderPresentationAdapter<Resource, View: InteractorResourceView> {
    
    typealias Loader = ((Result<Resource, Error>) -> Void) -> Void
        
    private let loader: Loader
    var presenter: InteractorPresenter<Resource, View>?
    
    init(loader: @escaping Loader) {
        self.loader = loader
    }
    
    func load() {
        presenter?.didStartLoading()
        
        loader { [weak self] result in
            switch result {
            case let .success(resource):
                self?.presenter?.didFinishLoading(with: resource)
            case let .failure(error):
                self?.presenter?.didFinishLoading(with: error)
            }
        }
    }
}
