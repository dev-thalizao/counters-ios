//
//  UIViewController+UI.swift
//  
//
//  Created by Thales Frigo on 20/05/21.
//

import Foundation

import UIKit

extension UIViewController {
    
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        
        child.view.frame = view.bounds
        child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        child.didMove(toParent: self)
    }

    func remove() {
        guard parent != nil else { return }

        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
