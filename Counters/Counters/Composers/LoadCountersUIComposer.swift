//
//  LoadCountersUIComposer.swift
//  Counters
//
//  Created by Thales Frigo on 26/05/21.
//

import UIKit
import CounterCore
import CounterPresentation
import CounterUI

private typealias LoaderPresentationAdapter = InteractorLoaderPresentationAdapter<[Counter], LoadViewAdapter>
private typealias CounterPresentationAdapter = InteractorLoaderPresentationAdapter<Counter, CounterViewAdapter>

public final class LoadCountersUIComposer {

    private init() {}
    
    public static func counterComposedWith(
        counterLoader: CounterLoader,
        counterIncrementer: CounterIncrementer,
        counterDecrementer: CounterDecrementer,
        onAdd: @escaping () -> Void = {},
        onErase: @escaping ([Counter]) -> Void = { _ in },
        onShare: @escaping ([Counter]) -> Void = { _ in }
    ) -> UIViewController {
        let adapter = LoaderPresentationAdapter(loader: counterLoader.load)
        let controller = CountersViewController()
        controller.onRefresh = adapter.load
        controller.title = CountersPresenter.title
        
        adapter.presenter = InteractorPresenter(
            resourceView: LoadViewAdapter(
                controller: controller,
                counterIncrementer: counterIncrementer,
                counterDecrementer: counterDecrementer,
                onErase: onErase,
                onShare: onShare
            ),
            loadingView: WeakRefVirtualProxy(controller),
            errorView: WeakRefVirtualProxy(controller)
        )
        
        controller.onAdd = onAdd
        
        return controller
    }
}

final class CounterViewAdapter: InteractorResourceView {
    
    private weak var controller: CountersViewController?
    
    init(controller: CountersViewController) {
        self.controller = controller
    }
    
    func display(viewModel: Counter) {
        controller?.onRefresh?()
    }
}

final class LoadViewAdapter: InteractorResourceView {
    
    private weak var controller: CountersViewController?
    
    private let counterIncrementer: CounterIncrementer
    private let counterDecrementer: CounterDecrementer
    private let onErase: ([Counter]) -> Void
    private let onShare: ([Counter]) -> Void
    
    private var currentCounters: [Counter]
    
    init(
        controller: CountersViewController,
        counterIncrementer: CounterIncrementer,
        counterDecrementer: CounterDecrementer,
        onErase: @escaping ([Counter]) -> Void,
        onShare: @escaping ([Counter]) -> Void,
        currentCounters: [Counter] = []
    ) {
        self.controller = controller
        self.counterIncrementer = counterIncrementer
        self.counterDecrementer = counterDecrementer
        self.onErase = onErase
        self.onShare = onShare
        self.currentCounters = currentCounters
        
        controller.onErase = onEraseAdapter
        controller.onShare = onShareAdapter
        controller.onSearch = onSearchAdapter
    }
    
    func display(viewModel: [Counter]) {
        self.currentCounters = viewModel
        
        let summary = CountersPresenter.map(viewModel)
        let cells = viewModel.map(onCounterAdapter)
        
        controller?.display(viewModel: summary)
        
        if cells.isEmpty {
            let starterView = CounterStarterView()
            starterView.onCreate = controller?.onAdd
            controller?.display(emptyView: starterView)
        } else {
            controller?.display(viewModel: cells)
        }
    }
    
    private func onCounterAdapter(_ model: Counter) -> CellController {
        let counterCell = CounterCellController(
            viewModel: CounterPresenter.map(model),
            onIncrease: onIncreaseAdapter(model),
            onDecrease: onDecreaseAdapter(model)
        )
        
        return CellController(id: model, dataSource: counterCell)
    }
    
    private func onIncreaseAdapter(_ model: Counter) -> (CounterCellController) -> Void {
        guard let view = controller else { return { _ in } }
        
        return { [model, incrementer = counterIncrementer, view] cell in
            let adapter = CounterPresentationAdapter(loader: { [incrementer] completion in
                incrementer.increment(model.id, completion: completion)
            })
            
            adapter.presenter = InteractorPresenter(
                resourceView: CounterViewAdapter(controller: view),
                loadingView: WeakRefVirtualProxy(cell),
                errorView: WeakRefVirtualProxy(view)
            )
            
            adapter.load()
        }
    }
    
    private func onDecreaseAdapter(_ model: Counter) -> (CounterCellController) -> Void {
        guard let view = controller else { return { _ in } }
        
        return { [model, decrementer = counterDecrementer, view] cell in
            let adapter = CounterPresentationAdapter(loader: { [decrementer] completion in
                decrementer.decrement(model.id, completion: completion)
            })
            
            adapter.presenter = InteractorPresenter(
                resourceView: CounterViewAdapter(controller: view),
                loadingView: WeakRefVirtualProxy(cell),
                errorView: WeakRefVirtualProxy(view)
            )
            
            adapter.load()
        }
    }
    
    private func onEraseAdapter(_ indexPaths: [IndexPath]) {
        onErase(indexPaths.map({ currentCounters[$0.row] }))
    }
    
    private func onShareAdapter(_ indexPaths: [IndexPath]) {
        onShare(indexPaths.map({ currentCounters[$0.row] }))
    }
    
    private func onSearchAdapter(_ text: String?) {
        guard let text = text, !text.isEmpty else {
            return display(viewModel: currentCounters)
        }
        
        let filteredCounters = currentCounters.filter { (counter) -> Bool in
            return counter.searchKey.contains(text.lowercased())
        }
        
        let summary = CountersPresenter.map(filteredCounters)
        let cells = filteredCounters.map(onCounterAdapter)
        
        controller?.display(viewModel: summary)
        
        if cells.isEmpty {
            controller?.display(emptyView: NoResultsView())
        } else {
            controller?.display(viewModel: cells)
        }
    }
}

private extension Counter {
    
    var searchKey: String {
        return "\(count);\(title)".lowercased()
    }
}
