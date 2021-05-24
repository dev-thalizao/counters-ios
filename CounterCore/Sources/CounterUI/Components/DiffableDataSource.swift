//
//  DiffableDataSource.swift
//  
//
//  Created by Thales Frigo on 20/05/21.
//

import UIKit

final class DiffableDataSource: NSObject {
    
    let dataSource: UITableViewDiffableDataSource<Int, CellController>
    
    private init(dataSource: UITableViewDiffableDataSource<Int, CellController>) {
        self.dataSource = dataSource
    }
    
    func display(_ sections: [CellController]...) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CellController>()
        sections.enumerated().forEach { section, cellControllers in
            snapshot.appendSections([section])
            snapshot.appendItems(cellControllers, toSection: section)
        }
        dataSource.apply(snapshot)
    }
    
    func cellController(at indexPath: IndexPath) -> CellController? {
        return dataSource.itemIdentifier(for: indexPath)
    }
}

// MARK: - Factory Methods

extension DiffableDataSource {
    
    static func diffable(with tableView: UITableView) -> DiffableDataSource {
        let dataSource = UITableViewDiffableDataSource<Int, CellController>(tableView: tableView) { (tableView, index, controller) in
            controller.dataSource.tableView(tableView, cellForRowAt: index)
        }
        dataSource.defaultRowAnimation = .fade
        return .init(dataSource: dataSource)
    }
}

// MARK: - UITableViewDelegate Methods

extension DiffableDataSource: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        let delegate = cellController(at: indexPath)?.delegate
        return delegate?.tableView?(tableView, shouldBeginMultipleSelectionInteractionAt: indexPath) ?? true
    }
    
    func tableView(_ tableView: UITableView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
//        let delegate = cellController(at: indexPath)?.delegate
//        delegate?.tableView?(tableView, didBeginMultipleSelectionInteractionAt: indexPath)
        tableView.setEditing(true, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let delegate = cellController(at: indexPath)?.delegate
        delegate?.tableView?(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let delegate = cellController(at: indexPath)?.delegate
        delegate?.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let delegate = cellController(at: indexPath)?.delegate
        delegate?.tableView?(tableView, didSelectRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let delegate = cellController(at: indexPath)?.delegate
        delegate?.tableView?(tableView, didDeselectRowAt: indexPath)
    }
}
