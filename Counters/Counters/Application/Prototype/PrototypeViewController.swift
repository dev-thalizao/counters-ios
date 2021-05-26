//
//  PrototypeViewController.swift
//  Counters
//
//  Created by Thales Frigo on 20/05/21.
//

import UIKit
import CounterUI

final class PrototypeComposer {
    
    static func prototype() -> UIViewController {
        let storyboard = UIStoryboard(name: "Prototype", bundle: .main)
        return storyboard.instantiateInitialViewController()!
    }
}

final class PrototypeCell: UITableViewCell {}

final class PrototypeItem {

    let count: Int
    var selected: Bool
    
    init(count: Int, selected: Bool) {
        self.count = count
        self.selected = selected
    }
}

final class PrototypeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var selectAllButton: UIBarButtonItem!
    @IBOutlet weak var trashButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    private let items = (0..<50).map({ PrototypeItem(count: $0, selected: false) })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigationItem()
    }
    
    private func configureTableView() {
        tableView.register(CounterCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private func configureNavigationItem() {
        navigationItem.searchController = searchController
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        print("\(#function)")
        tableView.setEditing(true, animated: true)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        print("\(#function)")
        tableView.setEditing(false, animated: true)
    }
    
    @IBAction func selectAllButtonTapped(_ sender: Any) {
        print("\(#function)")
        (0..<items.count)
            .map({ IndexPath(row: $0, section: 0) })
            .forEach({ tableView.selectRow(at: $0, animated: false, scrollPosition: .none) })
    }
    
    @IBAction func trashButtonTapped(_ sender: Any) {
        print("\(#function)")
    }
    
    @IBAction func sharedButtonTapped(_ sender: Any) {
        print("\(#function)")
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        print("\(#function)")
    }
}

extension PrototypeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CounterCell
        let item = items[indexPath.row]
        
        cell.configure(with: .init(count: item.count.description, title: indexPath.description))
        
        return cell
    }
}

extension PrototypeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        setEditing(true, animated: true)
        tableView.setEditing(true, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(#function)")
//        if tableView.isEditing {
//            // UPDATE COUNTER
//        } else {
//            tableView.deselectRow(at: indexPath, animated: true)
//        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("\(#function)")
//        if tableView.isEditing { // UPDATE COUNTER }
    }
}
