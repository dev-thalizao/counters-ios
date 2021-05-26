//
//  EraserViewController.swift
//  
//
//  Created by Thales Frigo on 26/05/21.
//

import UIKit
import CounterPresentation

public final class EraserViewController: UIViewController {
    public typealias Action = () -> Void
    
    public var onConfirm: Action?
    public var onFinish: Action?
    
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
            self?.onFinish?()
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
        alertVC.addAction(.init(title: "Ok", style: .default, handler: nil))
        
        present(alertVC, animated: true)
    }
}
