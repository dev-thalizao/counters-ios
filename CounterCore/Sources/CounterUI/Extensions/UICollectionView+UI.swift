//
//  UICollectionView+UI.swift
//  
//
//  Created by Thales Frigo on 27/05/21.
//

import UIKit

public extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_ :T.Type) {
        let identifier = String(describing: T.self)
        register(T.self, forCellWithReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! T
    }
}
