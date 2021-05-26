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
    typealias OnAdd = () -> Void
    typealias OnErase = ([IndexPath]) -> Void
    typealias OnShare = ([IndexPath]) -> Void
    
    private(set) lazy var contentView = CountersView()
    private(set) lazy var diffable = DiffableDataSource.diffable(with: contentView.tableView)
    
    private lazy var searchController = UISearchController(searchResultsController: nil)
    
    var onRefresh: OnRefresh?
    var onAdd: OnAdd?
    var onErase: OnErase?
    var onShare: OnShare?
    
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
        navigationItem.leftBarButtonItem = contentView.editButton
        navigationItem.largeTitleDisplayMode = .always
        
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        
    }
    
    private func configureToolbar() {
        setToolbarItems(contentView.toolbarDefaultItems(), animated: true)
    }
    
    private func configureContentView() {
        view.backgroundColor = contentView.backgroundColor
        contentView.delegate = self
        
        contentView.tableView.allowsMultipleSelectionDuringEditing = true
        
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
        contentView.tableView.setEditing(true, animated: true)
    }
    
    func countersViewDidEndEditing(_ view: CountersView) {
        navigationItem.setLeftBarButton(view.editButton, animated: true)
        navigationItem.setRightBarButton(nil, animated: true)
        setToolbarItems(view.toolbarDefaultItems(), animated: true)
        contentView.tableView.setEditing(false, animated: true)
    }
    
    func countersViewDidSendAdd(_ view: CountersView) {
        onAdd?()
    }
    
    func countersViewDidSendAction(_ view: CountersView) {
        guard
            view.tableView.isEditing,
            let indexPaths = view.tableView.indexPathsForSelectedRows,
            !indexPaths.isEmpty
        else { return }
        
        onShare?(indexPaths)
    }
    
    func countersViewDidSendTrash(_ view: CountersView) {
        guard
            view.tableView.isEditing,
            let indexPaths = view.tableView.indexPathsForSelectedRows,
            !indexPaths.isEmpty
        else { return }
        
        onErase?(indexPaths)
    }
}

// MARK: - InteractorLoadingView Methods

extension CountersViewController: InteractorResourceView {
    typealias InteractorResourceViewModel = CountersViewModel
    
    func display(viewModel: CountersViewModel) {
        contentView.summaryLabel.text = viewModel.summary
    }
}

// MARK: - InteractorLoadingView Methods

extension CountersViewController: InteractorLoadingView {
    
    func display(viewModel: InteractorLoadingViewModel) {
        contentView.tableView.refreshControl?.update(isRefreshing: viewModel.isLoading)
    }
}

// MARK: - InteractorErrorView Methods

extension CountersViewController: InteractorErrorView {
    
    func display(viewModel: InteractorErrorViewModel) {
        guard let reason = viewModel.reason else { return }
        
        let alertVC = UIAlertController(title: "Ops", message: reason, preferredStyle: .alert)
        alertVC.addAction(.init(title: "Ok", style: .default, handler: nil))
        
        present(alertVC, animated: true)
    }
}
