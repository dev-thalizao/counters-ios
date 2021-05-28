//
//  ExampleCountersCellController.swift
//  Counters
//
//  Created by Thales Frigo on 27/05/21.
//

import UIKit
import CounterUI

final class ExampleCountersCellController: NSObject {
    
    private let viewModels: [ExampleCategoryViewModel]
    private let selection: (ExampleCounterViewModel) -> Void
    private var cell: ExampleCounterTableCell?
    
    init(viewModels: [ExampleCategoryViewModel], selection: @escaping (ExampleCounterViewModel) -> Void) {
        self.viewModels = viewModels
        self.selection = selection
    }
}

extension ExampleCountersCellController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 26
//    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionLabel = ExampleCounterSectionView()
        sectionLabel.configure(with: viewModels[section].category)
        return sectionLabel
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        cell?.configure(with: viewModels[indexPath.section].items)
        cell?.onSelection = selection
        return cell!
    }
}
