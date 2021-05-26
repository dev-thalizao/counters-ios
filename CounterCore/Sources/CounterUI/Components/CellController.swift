//
//  CellController.swift
//  
//
//  Created by Thales Frigo on 20/05/21.
//

import UIKit

public final class CellController {

    let id: AnyHashable
    let dataSource: UITableViewDataSource
    let delegate: UITableViewDelegate?
    
    public init(id: AnyHashable, dataSource: UITableViewDataSource) {
        self.id = id
        self.dataSource = dataSource
        self.delegate = dataSource as? UITableViewDelegate
    }
}

extension CellController: Equatable {
    
    public static func == (lhs: CellController, rhs: CellController) -> Bool {
        return lhs.id == rhs.id
    }
}

extension CellController: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
