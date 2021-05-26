//
//  InteractorResourceViewSpy.swift
//  
//
//  Created by Thales Frigo on 19/05/21.
//

import Foundation
@testable import CounterPresentation

typealias TestPresenter = InteractorPresenter<String, InteractorResourceViewSpy>
typealias TestLoaderPresentationAdapter = InteractorLoaderPresentationAdapter<String, InteractorResourceViewSpy>

final class InteractorResourceViewSpy: InteractorResourceView, InteractorLoadingView, InteractorErrorView {
    
    enum Message: Equatable {
        case loading(isLoading: Bool)
        case success(resource: String)
        case error(reason: String?)
    }
    
    private(set) var messages = [Message]()
    
    func display(viewModel: InteractorLoadingViewModel) {
        messages.append(.loading(isLoading: viewModel.isLoading))
    }
    
    typealias InteractorResourceViewModel = String
    
    func display(viewModel: String) {
        messages.append(.success(resource: viewModel))
    }
    
    func display(viewModel: InteractorErrorViewModel) {
        messages.append(.error(reason: viewModel.reason))
    }
}
