//
//  InteractorLoaderPresentationAdapter.swift
//  
//
//  Created by Thales Frigo on 19/05/21.
//

import Foundation

public final class InteractorLoaderPresentationAdapter<Resource, View: InteractorResourceView> {
    
    public typealias Loader = (@escaping (Result<Resource, Error>) -> Void) -> Void
        
    private let loader: Loader
    public var presenter: InteractorPresenter<Resource, View>?
    
    public init(loader: @escaping Loader) {
        self.loader = loader
    }
    
    public func load() {
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
