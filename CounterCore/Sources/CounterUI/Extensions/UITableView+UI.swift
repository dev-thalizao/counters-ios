//
//  UITableView+UI.swift
//  
//
//  Created by Thales Frigo on 20/05/21.
//

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(_ :T.Type) {
        let identifier = String(describing: T.self)
        register(T.self, forCellReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
    
    var allIndexPaths: [IndexPath] {
        let indexPaths = (0..<numberOfSections).map({ (section) -> [IndexPath] in
            let rows = numberOfRows(inSection: section)
            return (0..<rows).map({ IndexPath(row: $0, section: section) })
        })
        
        return indexPaths.reduce([], +)
    }
    
    var indexPathForNonVisibleRows: [IndexPath]? {
        return indexPathsForVisibleRows
            .flatMap(Set.init)
            .flatMap({ $0.intersection(Set(allIndexPaths)) })
            .map(Array.init)
    }
}
