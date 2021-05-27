//
//  LoadingViewController.swift
//  
//
//  Created by Thales Frigo on 26/05/21.
//

import UIKit

final class LoadingViewController: UIViewController, ViewConfiguration {

    var isLoading: Bool {
        get { spinner.isAnimating }
        set {
            spinner.update(isAnimating: newValue)
        }
    }
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - ViewConfiguration Methods
    
    func setupHierarchy() {
        view.addSubview(spinner)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupViews() {
        view.backgroundColor = .systemBackground
    }
}

