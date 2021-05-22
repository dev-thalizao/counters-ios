//
//  CounterViewAdapter.swift
//  
//
//  Created by Thales Frigo on 20/05/21.
//

import UIKit
import CounterCore
import CounterPresentation

public final class CounterUIComposer {
    private init() {}
    
    private typealias CounterPresentationAdapter = InteractorLoaderPresentationAdapter<[Counter], CounterViewAdapter>
    
    public static func counterComposedWith(
        counterLoader: CounterLoader,
        selection: @escaping (Counter) -> Void = { _ in }
    ) -> UIViewController {
        let threadCounterLoader = MainQueueDispatchDecorator(decoratee: counterLoader)
        let presentationAdapter = CounterPresentationAdapter(loader: threadCounterLoader.load)
        let controller = CountersViewController()
        controller.onRefresh = presentationAdapter.load
        
        presentationAdapter.presenter = InteractorPresenter(
            resourceView: CounterViewAdapter(controller: controller),
            loadingView: WeakRefVirtualProxy(controller),
            errorView: WeakRefVirtualProxy(controller)
        )
        
        return controller
    }
}

final class CounterViewAdapter: InteractorResourceView {
    
    private weak var controller: CountersViewController?
    
    init(controller: CountersViewController) {
        self.controller = controller
    }
    
    func display(viewModel: [Counter]) {
        let viewModels = viewModel.map { model in
            return CellController(
                id: model,
                dataSource: CounterCellController(
                    viewModel: CounterPresenter.map(model),
                    selection: {}
                )
            )
        }
        
        controller?.diffable.display(viewModels)
    }
}
