//
//  EraserViewController.swift
//  
//
//  Created by Thales Frigo on 26/05/21.
//

import UIKit
import CounterPresentation

public final class EraserViewController: UIViewController {
    public typealias OnConfirm = () -> Void
    public typealias OnFinish = (EraserViewController) -> Void
    
    public var onConfirm: OnConfirm?
    public var onFinish: OnFinish?
    
    // MARK: - Lifecycle Methods
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentConfirmation()
    }
    
    // MARK: - Private Methods
    
    private func configureViews() {
        view.backgroundColor = .clear
    }
    
    private func presentConfirmation() {
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertVC.addAction(.init(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.onConfirm?()
        }))
        alertVC.addAction(.init(title: "Cancel", style: .cancel, handler: { [weak self] _ in
            guard let self = self else { return }
            self.onFinish?(self)
        }))
        
        present(alertVC, animated: true)
    }
}

// MARK: - InteractorLoadingView Methods

extension EraserViewController: InteractorLoadingView {
    
    public func display(viewModel: InteractorLoadingViewModel) {
        print(viewModel)
    }
}

// MARK: - InteractorErrorView Methods

extension EraserViewController: InteractorErrorView {

    public func display(viewModel: InteractorErrorViewModel) {
        guard let reason = viewModel.reason else { return }
        
        let alertVC = UIAlertController(title: "Ops", message: reason, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel) { [weak self] _ in
            guard let self = self else { return }
            self.onFinish?(self)
        }
        alertVC.addAction(dismissAction)
        
        present(alertVC, animated: true)
    }
}
