//
//  UIActivityIndicatorView+UI.swift
//  
//
//  Created by Thales Frigo on 22/05/21.
//

import UIKit

extension UIActivityIndicatorView {
    
    func update(isAnimating: Bool) {
        isAnimating ? startAnimating() : stopAnimating()
    }
}

extension UIActivityIndicatorView {
    
    static func animating(style: UIActivityIndicatorView.Style = .large) -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: style)
        spinner.startAnimating()
        return spinner
    }
}
