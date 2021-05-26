//
//  CountersViewController.swift
//  
//
//  Created by Thales Frigo on 22/05/21.
//

import UIKit
import CounterPresentation

public final class CountersViewController: UIViewController {
    public typealias Action = () -> Void
    public typealias OnErase = ([IndexPath]) -> Void
    public typealias OnShare = ([IndexPath]) -> Void
    
    private lazy var contentView = CountersView()
    private lazy var diffable = DiffableDataSource.diffable(with: contentView.tableView)
    
    private lazy var searchController = UISearchController(searchResultsController: nil)
    
    public var onRefresh: Action?
    public var onAdd: Action?
    public var onErase: OnErase?
    public var onShare: OnShare?
    
    // MARK: - View Lifecycle
    
    public override func loadView() {
        view = contentView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureContentView()
        configureNavigationItem()
        configureToolbar()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onRefresh?()
    }
    
    // MARK: - Private Methods
    
    private func configureNavigationItem() {
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
    
    // MARK: - Public Methods
    
    public func display(viewModel: CountersViewModel) {
        contentView.summaryLabel.text = viewModel.summary
    }
    
    public func display(viewModel: [CellController]) {
        diffable.display(viewModel)
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

extension CountersViewController: InteractorLoadingView {
    
    public func display(viewModel: InteractorLoadingViewModel) {
        contentView.tableView.refreshControl?.update(isRefreshing: viewModel.isLoading)
    }
}

// MARK: - InteractorErrorView Methods

extension CountersViewController: InteractorErrorView {
    
    public func display(viewModel: InteractorErrorViewModel) {
        guard let reason = viewModel.reason else { return }
        
        let alertVC = UIAlertController(title: "Ops", message: reason, preferredStyle: .alert)
        alertVC.addAction(.init(title: "Ok", style: .default, handler: nil))
        
        present(alertVC, animated: true)
    }
}
