//
//  CreateCounterUIComposer.swift
//  
//
//  Created by Thales Frigo on 22/05/21.
//

import UIKit
import CounterCore
import CounterPresentation

public final class CreateCounterUIComposer {
    private init() {}
    
    private typealias PresentationAdapter = InteractorLoaderPresentationAdapter<Counter, CreateCounterViewAdapter>
    
    public static func createComposedWith(
        idGenerator: @escaping () -> Counter.ID,
        counterCreator: CounterCreator,
        onFinish: @escaping (UIViewController) -> Void
    ) -> UIViewController {
        let controller = CreateCounterViewController()
        
        let presenter = InteractorPresenter(
            resourceView: CreateCounterViewAdapter(controller),
            loadingView: WeakRefVirtualProxy(controller),
            errorView: WeakRefVirtualProxy(controller)
        )
        
        controller.onFinish = onFinish
        controller.onSelect = { [counterCreator, presenter] name in
            let adapter = PresentationAdapter(loader: { completion in
                counterCreator.create(.init(id: idGenerator(), title: name), completion: completion)
            })
            
            adapter.presenter = presenter
            
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
