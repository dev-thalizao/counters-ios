//
//  UIViewController+UI.swift
//  
//
//  Created by Thales Frigo on 20/05/21.
//

import Foundation

import UIKit

extension UIViewController {
    
    func add(_ child: UIViewController, with frame: CGRect? = nil) {
        addChild(child)
        view.addSubview(child.view)
        
        child.view.frame = frame ?? view.bounds
        child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        child.didMove(toParent: self)
    }

    func remove() {
        guard parent != nil else { return }

        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    public func removeAnimated() {
        guard parent != nil else {
            return
        }
        
        UIView.animate(withDuration: 0.35, animations: { [weak self] in
            self?.view.alpha = 0
        }) { [weak self] (completion) in
            self?.remove()
            self?.view.alpha = 1
        }
    }
}
