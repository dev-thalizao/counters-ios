//
//  CountersView.swift
//  
//
//  Created by Thales Frigo on 22/05/21.
//

import UIKit

protocol CountersControlsDelegate: AnyObject {
    func countersControlsDidBeginEditing(_ countersControls: CountersControls)
    func countersControlsDidEndEditing(_ countersControls: CountersControls)
    func countersControlsDidSendAdd(_ countersControls: CountersControls)
    func countersControlsDidSendAction(_ countersControls: CountersControls)
    func countersControlsDidSendTrash(_ countersControls: CountersControls)
    func countersControlsDidSendSelectAll(_ countersControls: CountersControls)
}

final class CountersControls {
    
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
    
    private(set) lazy var trashButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapOnTrashButton(_:)))
    }()

    private(set) lazy var actionButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapOnActionButton(_:)))
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
    
    weak var delegate: CountersControlsDelegate?
    
    // MARK: - Actions
    
    @objc private func didTapOnEditButton(_ sender: UIBarButtonItem) {
        delegate?.countersControlsDidBeginEditing(self)
    }
    
    @objc private func didTapOnDoneButton(_ sender: UIBarButtonItem) {
        delegate?.countersControlsDidEndEditing(self)
    }
    
    @objc private func didTapOnSelectAllButton(_ sender: UIBarButtonItem) {
        delegate?.countersControlsDidSendSelectAll(self)
    }
    
    @objc private func didTapOnAddButton(_ sender: UIBarButtonItem) {
        delegate?.countersControlsDidSendAdd(self)
    }
    
    @objc private func didTapOnTrashButton(_ sender: UIBarButtonItem) {
        delegate?.countersControlsDidSendTrash(self)
    }
    
    @objc private func didTapOnActionButton(_ sender: UIBarButtonItem) {
        delegate?.countersControlsDidSendAction(self)
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
