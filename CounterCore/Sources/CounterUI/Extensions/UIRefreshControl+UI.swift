//
//  UIRefreshControl+UI.swift
//  
//
//  Created by Thales Frigo on 22/05/21.
//

import UIKit

extension UIRefreshControl {
    
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
