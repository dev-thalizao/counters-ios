//
//  CreateCounterViewController.swift
//  
//
//  Created by Thales Frigo on 22/05/21.
//

import UIKit
import CounterPresentation

public final class CreateCounterViewController: UIViewController {

    public typealias OnFinish = (CreateCounterViewController) -> Void
    public typealias OnSelect = (CreateCounterViewController, String) -> Void
    
    public var onFinish: OnFinish?
    public var onSelect: OnSelect?
    
    private lazy var contentView = CreateCounterView()
    
    public override func loadView() {
        view = contentView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureContentView()
        configureNavigationItem()
    }
    
    private func configureContentView() {
        contentView.delegate = self
    }
    
    private func configureNavigationItem() {
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
        onSelect?(self, name)
    }
}

// MARK: - InteractorLoadingVInteractorLoadingViewiew Methods

extension CreateCounterViewController: InteractorLoadingView {
    
    public func display(viewModel: InteractorLoadingViewModel) {
        contentView.activityIndicator.update(isAnimating: viewModel.isLoading)
    }
}

// MARK: - InteractorErrorView Methods

extension CreateCounterViewController: InteractorErrorView {
    
    public func display(viewModel: InteractorErrorViewModel) {
        guard let reason = viewModel.reason else { return }
        
        let alertVC = UIAlertController(title: "Ops", message: reason, preferredStyle: .alert)
        alertVC.addAction(.init(title: "Ok", style: .default, handler: nil))
        
        present(alertVC, animated: true)
    }
}
