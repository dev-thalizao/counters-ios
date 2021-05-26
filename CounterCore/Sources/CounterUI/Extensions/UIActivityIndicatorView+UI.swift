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
