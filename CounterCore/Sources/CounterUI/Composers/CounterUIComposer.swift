//
//  CounterUIComposer.swift
//  
//
//  Created by Thales Frigo on 22/05/21.
//

import UIKit
import CounterCore
import CounterPresentation

private typealias LoaderPresentationAdapter = InteractorLoaderPresentationAdapter<[Counter], LoaderViewAdapter>
private typealias IncrementerPresentationAdapter = InteractorLoaderPresentationAdapter<CounterViewModel, WeakRefVirtualProxy<CounterCellController>>
private typealias DecrementerPresentationAdapter = InteractorLoaderPresentationAdapter<CounterViewModel, WeakRefVirtualProxy<CounterCellController>>
private typealias EraserPresentationAdapter = InteractorLoaderPresentationAdapter<Void, EraseViewAdapter>

public final class CounterUIComposer {
    
    private init() {}
    
    public static func counterComposedWith(
        counterLoader: CounterLoader,
        counterIncrementer: CounterIncrementer,
        counterDecrementer: CounterDecrementer,
        counterEraser: CounterEraser,
        onAdd: @escaping () -> Void = {}
    ) -> UIViewController {
        let adapter = LoaderPresentationAdapter(loader: counterLoader.load)
        let controller = CountersViewController()
        controller.onRefresh = adapter.load
        
        adapter.presenter = InteractorPresenter(
            resourceView: LoaderViewAdapter(
                controller: controller,
                counterIncrementer: counterIncrementer,
                counterDecrementer: counterDecrementer,
                counterEraser: counterEraser
            ),
            loadingView: WeakRefVirtualProxy(controller),
            errorView: WeakRefVirtualProxy(controller)
        )
        
        controller.onAdd = onAdd
        
        return controller
    }
}

final class LoaderViewAdapter: InteractorResourceView {
    
    private weak var controller: CountersViewController?
    
    private let counterIncrementer: CounterIncrementer
    private let counterDecrementer: CounterDecrementer
    private let counterEraser: CounterEraser
    private var currentCounters: [Counter]
    
    init(
        controller: CountersViewController,
        counterIncrementer: CounterIncrementer,
        counterDecrementer: CounterDecrementer,
        counterEraser: CounterEraser,
        currentCounters: [Counter] = []
    ) {
        self.controller = controller
        self.counterIncrementer = counterIncrementer
        self.counterDecrementer = counterDecrementer
        self.counterEraser = counterEraser
        self.currentCounters = currentCounters
    }
    
    func display(viewModel: [Counter]) {
        self.currentCounters = viewModel
        
        let viewModels = viewModel.map { model -> CellController in
            let counterCell = CounterCellController(
                viewModel: CounterPresenter.map(model),
                onIncrease: onIncreaseAdapter(model),
                onDecrease: onDecreaseAdapter(model)
            )
            
            return CellController(id: model, dataSource: counterCell)
        }
        
        controller?.display(viewModel: CountersPresenter.map(viewModel))
        controller?.diffable.display(viewModels)
        controller?.onErase = onEraseAdapter(viewModel)
    }
    
    private func onIncreaseAdapter(_ model: Counter) -> (CounterCellController) -> Void {
        guard let view = controller else { return { _ in } }
        
        return { [model, incrementer = counterIncrementer, view] cell in
            let adapter = IncrementerPresentationAdapter(loader: { [incrementer] completion in
                incrementer.increment(model.id) { result in
                    completion(result.flatMap { counter -> Result<CounterViewModel, Error> in
                        return .success(CounterPresenter.map(counter))
                    })
                }
            })
            
            adapter.presenter = InteractorPresenter(
                resourceView: WeakRefVirtualProxy(cell),
                loadingView: WeakRefVirtualProxy(cell),
                errorView: WeakRefVirtualProxy(view)
            )
            
            adapter.load()
        }
    }
    
    private func onDecreaseAdapter(_ model: Counter) -> (CounterCellController) -> Void {
        guard let view = controller else { return { _ in } }
        
        return { [model, decrementer = counterDecrementer, view] cell in
            let adapter = IncrementerPresentationAdapter(loader: { [decrementer] completion in
                decrementer.decrement(model.id) { result in
                    completion(result.flatMap { counter -> Result<CounterViewModel, Error> in
                        return .success(CounterPresenter.map(counter))
                    })
                }
            })
            
            adapter.presenter = InteractorPresenter(
                resourceView: WeakRefVirtualProxy(cell),
                loadingView: WeakRefVirtualProxy(cell),
                errorView: WeakRefVirtualProxy(view)
            )
            
            adapter.load()
        }
    }
    
    private func onEraseAdapter(_ models: [Counter]) -> ([IndexPath]) -> Void {
        guard let view = controller else { return { _ in } }
        
        return { [models, eraser = counterEraser, view] indexPaths in
            
            let ids = indexPaths.map({ models[$0.row] }).map(\.id)
            
            let adapter = EraserPresentationAdapter(loader: { [eraser, ids] completion in
                eraser.erase(ids, completion: completion)
            })
            
            adapter.presenter = InteractorPresenter(
                resourceView: EraseViewAdapter(controller: view),
                loadingView: WeakRefVirtualProxy(view),
                errorView: WeakRefVirtualProxy(view)
            )
            
            adapter.load()
        }
    }
}

final class EraseViewAdapter: InteractorResourceView {
    
    private weak var controller: CountersViewController?
    
    init(controller: CountersViewController) {
        self.controller = controller
    }
    
    func display(viewModel: Void) {
        controller?.onRefresh?()
    }
}
