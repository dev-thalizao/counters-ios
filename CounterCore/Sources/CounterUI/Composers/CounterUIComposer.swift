//
//  CounterUIComposer.swift
//  
//
//  Created by Thales Frigo on 22/05/21.
//

import UIKit
import CounterCore
import CounterPresentation

private typealias LoaderPresentationAdapter = InteractorLoaderPresentationAdapter<[Counter], CounterViewAdapter>
private typealias IncrementerPresentationAdapter = InteractorLoaderPresentationAdapter<CounterViewModel, WeakRefVirtualProxy<CounterCellController>>
private typealias DecrementerPresentationAdapter = InteractorLoaderPresentationAdapter<CounterViewModel, WeakRefVirtualProxy<CounterCellController>>

public final class CounterUIComposer {
    
    private init() {}
    
    public static func counterComposedWith(
        counterLoader: CounterLoader,
        counterIncrementer: CounterIncrementer,
        counterDecrementer: CounterDecrementer,
        onAdd: @escaping () -> Void = {}
    ) -> UIViewController {
        let adapter = LoaderPresentationAdapter(loader: counterLoader.load)
        let controller = CountersViewController()
        controller.onRefresh = adapter.load
        
        adapter.presenter = InteractorPresenter(
            resourceView: CounterViewAdapter(
                controller: controller,
                counterIncrementer: counterIncrementer,
                counterDecrementer: counterDecrementer
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
    
    private let counterIncrementer: CounterIncrementer
    private let counterDecrementer: CounterDecrementer
    
    init(
        controller: CountersViewController,
        counterIncrementer: CounterIncrementer,
        counterDecrementer: CounterDecrementer
    ) {
        self.controller = controller
        self.counterIncrementer = counterIncrementer
        self.counterDecrementer = counterDecrementer
    }
    
    func display(viewModel: [Counter]) {
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
}
