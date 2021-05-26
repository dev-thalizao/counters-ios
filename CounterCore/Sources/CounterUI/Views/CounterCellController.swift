//
//  CounterCellCountroller.swift
//  
//
//  Created by Thales Frigo on 20/05/21.
//

import UIKit
import CounterPresentation

final class CounterCellController: NSObject {
    typealias CounterChanged = (CounterCellController) -> Void
    
    private let viewModel: CounterViewModel
    public let onIncrease: CounterChanged
    public let onDecrease: CounterChanged
    
    private var cell: CounterCell?
    
    internal init(viewModel: CounterViewModel, onIncrease: @escaping CounterChanged, onDecrease: @escaping CounterChanged) {
        self.viewModel = viewModel
        self.onIncrease = onIncrease
        self.onDecrease = onDecrease
    }
}

extension CounterCellController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        cell?.counterView.configure(with: viewModel)
        cell?.counterView.onCounterStepperChanged = { [unowned self] newCounter in
            guard let currentCounter = Int(viewModel.count) else { return }
            newCounter > currentCounter
                ? self.onIncrease(self)
                : self.onDecrease(self)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !tableView.isEditing else { return }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        tableView.setEditing(true, animated: true)
    }
}

extension CounterCellController: InteractorLoadingView {

    func display(viewModel: InteractorLoadingViewModel) {
        cell?.counterView.counterStepper.isEnabled = !viewModel.isLoading
    }
}
