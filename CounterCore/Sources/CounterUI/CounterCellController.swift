//
//  CounterCellCountroller.swift
//  
//
//  Created by Thales Frigo on 20/05/21.
//

import UIKit
import CounterPresentation

final class CounterCellController: NSObject {
    
    private let viewModel: CounterViewModel
    private let selection: () -> Void
    private var cell: CounterCell?
    
    init(viewModel: CounterViewModel, selection: @escaping () -> Void) {
        self.viewModel = viewModel
        self.selection = selection
    }
}

extension CounterCellController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        cell?.textLabel?.text = viewModel.title
        cell?.detailTextLabel?.text = viewModel.count
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selection()
    }
}
