//
//  ExampleViewController.swift
//  Counters
//
//  Created by Thales Frigo on 27/05/21.
//

import UIKit
import CounterUI

protocol ExampleCountersViewControllerPresenter {
    var title: String { get }
    var viewModel: ExampleCountersViewModel { get }
}

final class ExampleCountersViewController: UITableViewController {
    typealias OnSelect = (ExampleCountersViewController, ExampleCounterViewModel) -> Void
    
    private let presenter: ExampleCountersViewControllerPresenter
    
    private lazy var cellController: ExampleCountersCellController = {
        return ExampleCountersCellController(
            viewModels: presenter.viewModel.categories,
            selection: { [weak self] selectedViewModel in
                guard let self = self else { return }
                self.onSelect?(self, selectedViewModel)
            }
        )
    }()
    
    var onSelect: OnSelect?
    
    init(presenter: ExampleCountersViewControllerPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.title = presenter.title
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        renderViewModels()
    }
    
    private func configureTableView() {
        tableView.register(ExampleCounterTableCell.self)
        tableView.dataSource = cellController
        tableView.delegate = cellController
        tableView.rowHeight = 90
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
        
        let hintView = ExampleCounterHintView(
            frame: .init(origin: .zero, size: .init(width: tableView.frame.width, height: 50))
        )
        hintView.configure(with: presenter.viewModel.hint)
        tableView.tableHeaderView = hintView
    }
    
    private func renderViewModels() {
        tableView.reloadData()
    }
}

