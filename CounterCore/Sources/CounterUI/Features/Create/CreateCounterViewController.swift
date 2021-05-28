//
//  CreateCounterViewController.swift
//  
//
//  Created by Thales Frigo on 22/05/21.
//

import UIKit
import CounterPresentation

public final class CreateCounterViewController: UIViewController {

    public typealias OnSeeExamples = (CreateCounterViewController, @escaping (String) -> Void) -> Void
    public typealias OnFinish = (CreateCounterViewController) -> Void
    public typealias OnSelect = (CreateCounterViewController, String) -> Void
    
    public var onFinish: OnFinish?
    public var onSelect: OnSelect?
    public var onSeeExamples: OnSeeExamples?
    
    private lazy var contentView = CreateCounterView()
    
    public override func loadView() {
        view = contentView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureContentView()
        configureNavigationItem()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentView.textField.becomeFirstResponder()
    }
    
    private func configureContentView() {
        contentView.delegate = self
        contentView.hintTextView.delegate = self
    }
    
    private func configureNavigationItem() {
        navigationItem.leftBarButtonItem = contentView.cancelButton
        navigationItem.rightBarButtonItem = contentView.saveButton
    }
    
    private func input(text: String) {
        contentView.textField.text = text
        contentView.textField.sendActions(for: .editingChanged)
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

// MARK: - UITextViewDelegate Methods

extension CreateCounterViewController: UITextViewDelegate {
    
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        onSeeExamples?(self, input(text:))
        
        return false
    }
}
