//
//  CountersViewController.swift
//  
//
//  Created by Thales Frigo on 22/05/21.
//

import UIKit

final class CountersViewController: UIViewController {
    
    private lazy var contentView = CountersView()
    private lazy var diffable = DiffableDataSource(tableView: contentView.tableView)
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.delegate = self
        navigationItem.title = "Counters"
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        navigationItem.leftBarButtonItem = contentView.editButton
        
        contentView.tableView.dataSource = diffable.dataSource
        contentView.tableView.delegate = diffable
    }
}

extension CountersViewController: CountersViewDelegate {
    
    func countersViewDidBeginEditing(_ view: CountersView) {
        navigationItem.setLeftBarButton(view.doneButton, animated: true)
        navigationItem.setRightBarButton(view.selectAllButton, animated: true)
    }
    
    func countersViewDidEndEditing(_ view: CountersView) {
        navigationItem.setLeftBarButton(view.editButton, animated: true)
        navigationItem.setRightBarButton(nil, animated: false)
    }
    
    func countersViewDidSendAdd(_ view: CountersView) {
        present(UIViewController(), animated: true)
    }
    
    func countersViewDidSendAction(_ view: CountersView) {
        let shareVC = UIActivityViewController(activityItems: ["Hey i'm sharing"], applicationActivities: nil)
        present(shareVC, animated: true)
    }
    
    func countersViewDidSendTrash(_ view: CountersView) {
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertVC.addAction(.init(title: "Delete", style: .destructive, handler: nil))
        alertVC.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertVC, animated: true)
    }
}
