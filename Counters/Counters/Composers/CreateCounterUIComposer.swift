//
//  CreateCounterUIComposer.swift
//  Counters
//
//  Created by Thales Frigo on 26/05/21.
//

import UIKit
import CounterCore
import CounterPresentation
import CounterUI

private typealias CreatePresentationAdapter = InteractorLoaderPresentationAdapter<Counter, CreateCounterViewAdapter>

public final class CreateCounterUIComposer {
    
    private init() {}
    
    public static func createComposedWith(
        idGenerator: @escaping () -> Counter.ID,
        counterCreator: CounterCreator,
        onFinish: @escaping (UIViewController) -> Void
    ) -> UIViewController {
        let controller = CreateCounterViewController()
        controller.title = CreateCounterPresenter.title
        
        controller.onFinish = onFinish
        controller.onSelect = { [counterCreator] controller, name in
            let adapter = CreatePresentationAdapter(loader: { completion in
                counterCreator.create(.init(id: idGenerator(), title: name), completion: completion)
            })
            
            adapter.presenter = InteractorPresenter(
                resourceView: CreateCounterViewAdapter(controller),
                loadingView: WeakRefVirtualProxy(controller),
                errorView: WeakRefVirtualProxy(controller)
            )
            
            adapter.load()
        }
        
        return controller
    }
}

final class CreateCounterViewAdapter: InteractorResourceView {
    
    weak var controller: CreateCounterViewController?
    
    init(_ controller: CreateCounterViewController) {
        self.controller = controller
    }
    
    func display(viewModel: Counter) {
        guard let controller = controller else { return }
        
        controller.onFinish?(controller)
    }
}
