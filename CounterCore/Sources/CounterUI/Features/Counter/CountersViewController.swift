//
//  CountersViewController.swift
//  
//
//  Created by Thales Frigo on 22/05/21.
//

import UIKit
import CounterPresentation

public final class CountersViewController: UITableViewController {
    public typealias Action = () -> Void
    public typealias OnErase = ([IndexPath]) -> Void
    public typealias OnShare = ([IndexPath]) -> Void
    public typealias OnSearch = (String?) -> Void
    
    private lazy var countersControls = CountersControls()
    private lazy var diffable = DiffableDataSource.diffable(with: tableView)
    
    private lazy var searchController = UISearchController(searchResultsController: nil)
    private lazy var loadingController = LoadingViewController()
    
    public var onRefresh: Action?
    public var onAdd: Action?
    public var onErase: OnErase?
    public var onShare: OnShare?
    public var onSearch: OnSearch?
    
    // MARK: - View Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureCountersControls()
        configureNavigationItem()
        configureSearchController()
        configureToolbar()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onRefresh?()
    }
    
    // MARK: - Private Methods
    
    private func configureTableView() {
        tableView.register(CounterCell.self)
        tableView.backgroundColor = Layout.TableView.color
        tableView.estimatedRowHeight = Layout.TableView.estimatedRowHeight
        tableView.rowHeight = Layout.TableView.rowHeight
        tableView.separatorStyle = Layout.TableView.separatorStyle
        tableView.contentInset = Layout.TableView.contentInset
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.dataSource = diffable.dataSource
        tableView.delegate = diffable
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    private func configureNavigationItem() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = countersControls.editButton
        navigationItem.searchController = searchController
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func configureToolbar() {
        setToolbarItems(countersControls.toolbarDefaultItems(), animated: true)
    }
    
    private func configureCountersControls() {
        countersControls.delegate = self
    }
    
    // MARK: - Actions Methods
    
    @objc private func didPullToRefresh(_ sender: UIRefreshControl) {
        onRefresh?()
    }
    
    // MARK: - Public Methods
    
    public func display(viewModel: CountersViewModel) {
        countersControls.summaryLabel.text = viewModel.summary
        countersControls.summaryLabel.sizeToFit()
    }
    
    public func display(viewModel: [CellController]) {
        tableView.backgroundView = nil
        
        diffable.display(viewModel)
        
        if tableView.isEditing {
            countersControlsDidEndEditing(countersControls)
        }
    }
    
    public func display(emptyView: UIView) {
        tableView.backgroundView = emptyView
        
        diffable.display([])
        
        if tableView.isEditing {
            countersControlsDidEndEditing(countersControls)
        }
    }
}

// MARK: - CountersViewDelegate Methods

extension CountersViewController: CountersControlsDelegate {
    
    func countersControlsDidBeginEditing(_ countersControls: CountersControls) {
        navigationItem.setLeftBarButton(countersControls.doneButton, animated: true)
        navigationItem.setRightBarButton(countersControls.selectAllButton, animated: true)
        setToolbarItems(countersControls.toolbarEditItems(), animated: true)
        tableView.setEditing(true, animated: true)
    }
    
    func countersControlsDidEndEditing(_ countersControls: CountersControls) {
        navigationItem.setLeftBarButton(countersControls.editButton, animated: true)
        navigationItem.setRightBarButton(nil, animated: true)
        setToolbarItems(countersControls.toolbarDefaultItems(), animated: true)
        tableView.setEditing(false, animated: true)
    }
    
    func countersControlsDidSendAdd(_ countersControls: CountersControls) {
        onAdd?()
    }
    
    func countersControlsDidSendAction(_ countersControls: CountersControls) {
        guard
            tableView.isEditing,
            let indexPaths = tableView.indexPathsForSelectedRows,
            !indexPaths.isEmpty
        else { return }
        
        onShare?(indexPaths)
    }
    
    func countersControlsDidSendTrash(_ countersControls: CountersControls) {
        guard
            tableView.isEditing,
            let indexPaths = tableView.indexPathsForSelectedRows,
            !indexPaths.isEmpty
        else { return }
        
        onErase?(indexPaths)
    }
    
    func countersControlsDidSendSelectAll(_ countersControls: CountersControls) {
        tableView.allIndexPaths.forEach {
            tableView.selectRow(at: $0, animated: false, scrollPosition: .none)
        }
    }
}

// MARK: - InteractorLoadingView Methods

extension CountersViewController: InteractorLoadingView {
    
    public func display(viewModel: InteractorLoadingViewModel) {
        switch (viewModel.isLoading, tableView.allIndexPaths.isEmpty) {
        case (true, true):
            loadingController.isLoading = true
            add(loadingController, with: loadingViewFrame())
        case (false, true):
            loadingController.isLoading = false
            loadingController.removeAnimated()
        case (true, false):
            tableView.refreshControl?.update(isRefreshing: true)
        case (false, false):
            tableView.refreshControl?.update(isRefreshing: false)
        }
    }
    
    private func loadingViewFrame() -> CGRect {
        var frame = tableView.frame
        frame.size.height -= (navigationController?.navigationBar.frame.height ?? 0)
        frame.size.height -= (navigationController?.toolbar.frame.height ?? 0)
        return frame
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

// MARK: - UISearchResultsUpdating Methods

extension CountersViewController: UISearchResultsUpdating {
    
    public func updateSearchResults(for searchController: UISearchController) {
        onSearch?(searchController.searchBar.text)
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        onSearch?(nil)
    }
}

// MARK: - UISearchBarDelegate Methods

extension CountersViewController: UISearchBarDelegate {
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - Layout Constants

extension CountersViewController {
    
    enum Layout {
        
        enum TableView {
            static let color = UIColor.systemGroupedBackground
            static let estimatedRowHeight = CGFloat(120)
            static let rowHeight = UITableView.automaticDimension
            static let separatorStyle = UITableViewCell.SeparatorStyle.none
            static let contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        }
    }
}
