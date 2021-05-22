//
//  CountersViewController.swift
//  
//
//  Created by Thales Frigo on 22/05/21.
//

import UIKit
import CounterPresentation

final class CountersViewController: UIViewController {
    
    typealias OnRefresh = () -> Void
    
    private(set) lazy var contentView = CountersView()
    private(set) lazy var diffable = DiffableDataSource.diffable(with: contentView.tableView)
    
    var onRefresh: OnRefresh?
    
    // MARK: - View Lifecycle
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContentView()
        configureNavigationItem()
        configureToolbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onRefresh?()
    }
    
    // MARK: - Private Methods
    
    private func configureNavigationItem() {
        navigationItem.title = "Counters"
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        navigationItem.leftBarButtonItem = contentView.editButton
    }
    
    private func configureToolbar() {
        setToolbarItems(contentView.toolbarDefaultItems(), animated: true)
    }
    
    private func configureContentView() {
        view.backgroundColor = .systemBackground
        contentView.delegate = self
        contentView.tableView.dataSource = diffable.dataSource
        contentView.tableView.delegate = diffable
    }
}

// MARK: - CountersViewDelegate Methods

extension CountersViewController: CountersViewDelegate {
    
    func countersViewDidBeginEditing(_ view: CountersView) {
        navigationItem.setLeftBarButton(view.doneButton, animated: true)
        navigationItem.setRightBarButton(view.selectAllButton, animated: true)
        setToolbarItems(view.toolbarEditItems(), animated: true)
    }
    
    func countersViewDidEndEditing(_ view: CountersView) {
        navigationItem.setLeftBarButton(view.editButton, animated: true)
        navigationItem.setRightBarButton(nil, animated: false)
        setToolbarItems(view.toolbarDefaultItems(), animated: true)
    }
    
    func countersViewDidSendAdd(_ view: CountersView) {
        let blankVC = UIViewController()
        blankVC.view.backgroundColor = .systemPink
        
        present(blankVC, animated: true)
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

// MARK: - InteractorLoadingView Methods

extension CountersViewController: InteractorLoadingView, InteractorErrorView {
    
    func display(_ viewModel: InteractorLoadingViewModel) {
        contentView.tableView.refreshControl?.update(isRefreshing: viewModel.isLoading)
    }
}

// MARK: - InteractorErrorView Methods

extension CountersViewController: InteractorErrorView {
    
    func display(_ viewModel: InteractorErrorViewModel) {
        guard let reason = viewModel.reason else { return }
        
        let alertVC = UIAlertController(title: "Ops", message: reason, preferredStyle: .alert)
        alertVC.addAction(.init(title: "Ok", style: .default, handler: nil))
        
        present(alertVC, animated: true)
    }
}


