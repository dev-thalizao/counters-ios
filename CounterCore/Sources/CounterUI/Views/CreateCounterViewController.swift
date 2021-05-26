//
//  CreateCounterViewController.swift
//  
//
//  Created by Thales Frigo on 22/05/21.
//

import UIKit
import CounterPresentation

final class CreateCounterViewController: UIViewController {

    typealias OnFinish = (CreateCounterViewController) -> Void
    typealias OnSelect = (String) -> Void
    
    var onFinish: OnFinish?
    var onSelect: OnSelect?
    
    private lazy var contentView = CreateCounterView()
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContentView()
        configureNavigationItem()
    }
    
    private func configureContentView() {
        contentView.delegate = self
    }
    
    private func configureNavigationItem() {
        navigationItem.title = "Create a counter"
        navigationItem.leftBarButtonItem = contentView.cancelButton
        navigationItem.rightBarButtonItem = contentView.saveButton
    }
}

// MARK: - CreateCounterViewDelegate Methods

extension CreateCounterViewController: CreateCounterViewDelegate {
    
    func createCounterViewDidCancel(_ createCounterView: CreateCounterView) {
        onFinish?(self)
    }
    
    func createCounterView(_ createCounterView: CreateCounterView, didSelectName name: String) {
        onSelect?(name)
    }
}

// MARK: - InteractorLoadingVInteractorLoadingViewiew Methods

extension CreateCounterViewController: InteractorLoadingView {
    
    func display(viewModel: InteractorLoadingViewModel) {
        contentView.activityIndicator.update(isAnimating: viewModel.isLoading)
    }
}

// MARK: - InteractorErrorView Methods

extension CreateCounterViewController: InteractorErrorView {
    
    func display(viewModel: InteractorErrorViewModel) {
        guard let reason = viewModel.reason else { return }
        
        let alertVC = UIAlertController(title: "Ops", message: reason, preferredStyle: .alert)
        alertVC.addAction(.init(title: "Ok", style: .default, handler: nil))
        
        present(alertVC, animated: true)
    }
}
