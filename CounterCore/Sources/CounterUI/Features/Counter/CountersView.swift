//
//  CountersView.swift
//  
//
//  Created by Thales Frigo on 22/05/21.
//

import UIKit

protocol CountersViewDelegate: AnyObject {
    func countersViewDidBeginEditing(_ countersView: CountersView)
    func countersViewDidEndEditing(_ countersView: CountersView)
    func countersViewDidSendAdd(_ countersView: CountersView)
    func countersViewDidSendAction(_ countersView: CountersView)
    func countersViewDidSendTrash(_ countersView: CountersView)
}

final class CountersView: UIView {
    
    // MARK: - Properties
    
    private(set) lazy var editButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didTapOnEditButton(_:)))
    }()
    
    private(set) lazy var doneButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapOnDoneButton(_:)))
    }()
    
    private(set) lazy var selectAllButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "Select All", style: .plain, target: self, action: #selector(didTapOnSelectAllButton(_:)))
    }()
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CounterCell.self)
        tableView.backgroundColor = Layout.TableView.color
        tableView.estimatedRowHeight = Layout.TableView.estimatedRowHeight
        tableView.rowHeight = Layout.TableView.rowHeight
        tableView.separatorStyle = Layout.TableView.separatorStyle
        tableView.contentInset = Layout.TableView.contentInset
        tableView.allowsMultipleSelectionDuringEditing = true
        return tableView
    }()
    
    private(set) lazy var trashButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapOnTrashButton(_:)))
        return barButton
    }()

    private(set) lazy var actionButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapOnActionButton(_:)))
        return barButton
    }()
    
    private(set) lazy var summaryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private(set) lazy var summaryButton: UIBarButtonItem = {
        return UIBarButtonItem(customView: summaryLabel)
    }()
    
    private(set) lazy var addButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapOnAddButton(_:)))
    }()
    
    weak var delegate: CountersViewDelegate?
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Actions
    
    @objc private func didTapOnEditButton(_ sender: UIBarButtonItem) {
        delegate?.countersViewDidBeginEditing(self)
    }
    
    @objc private func didTapOnDoneButton(_ sender: UIBarButtonItem) {
        delegate?.countersViewDidEndEditing(self)
    }
    
    @objc private func didTapOnSelectAllButton(_ sender: UIBarButtonItem) {
        tableView.allIndexPaths.forEach {
            tableView.selectRow(at: $0, animated: false, scrollPosition: .none)
        }
    }
    
    @objc private func didTapOnAddButton(_ sender: UIBarButtonItem) {
        delegate?.countersViewDidSendAdd(self)
    }
    
    @objc private func didTapOnTrashButton(_ sender: UIBarButtonItem) {
        delegate?.countersViewDidSendTrash(self)
    }
    
    @objc private func didTapOnActionButton(_ sender: UIBarButtonItem) {
        delegate?.countersViewDidSendAction(self)
    }
    
    // MARK: - Helpers
    
    func toolbarDefaultItems() -> [UIBarButtonItem] {
        return [fixedSpace(), flexibleSpace(), summaryButton, flexibleSpace(), addButton]
    }
    
    func toolbarEditItems() -> [UIBarButtonItem] {
        return [trashButton, flexibleSpace(), actionButton]
    }
    
    private func fixedSpace() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
    }
    
    private func flexibleSpace() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }
}

// MARK: - ViewConfiguration Methods

extension CountersView: ViewConfiguration {
    
    func setupHierarchy() {
        addSubview(tableView)
    }
    
    func setupConstraints() {
        let guide = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
        ])
    }
    
    func setupViews() {
        backgroundColor = .systemBackground
    }
}

// MARK: - Layout Constants

extension CountersView {
    
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
