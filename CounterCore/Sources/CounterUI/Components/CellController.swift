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
    
    init(id: AnyHashable, dataSource: UITableViewDataSource, delegate: UITableViewDelegate? = nil) {
        self.id = id
        self.dataSource = dataSource
        self.delegate = delegate
    }
}

extension CellController: Equatable {
    
    public static func == (lhs: CellController, rhs: CellController) -> Bool {
        lhs.id == rhs.id
    }
}

extension CellController: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
