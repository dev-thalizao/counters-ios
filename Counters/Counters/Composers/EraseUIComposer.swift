//
//  EraseCountersUIComposer.swift
//  Counters
//
//  Created by Thales Frigo on 26/05/21.
//

import UIKit
import CounterCore
import CounterPresentation
import CounterUI

private typealias PresentationAdapter = InteractorLoaderPresentationAdapter<Void, EraseViewControllerAdapter>

public final class EraseCountersUIComposer {
    
    private init() {}
    
    public static func eraseComposedWith(
        counters: [Counter],
        counterEraser: CounterEraser,
        onFinish: @escaping () -> Void
    ) -> UIViewController {
        let controller = EraserViewController()
        
        let adapter = PresentationAdapter(loader: { [counterEraser] completion in
            counterEraser.erase(counters.map(\.id), completion: completion)
        })
        
        adapter.presenter = InteractorPresenter(
            resourceView: EraseViewControllerAdapter(controller: controller),
            loadingView: WeakRefVirtualProxy(controller),
            errorView: WeakRefVirtualProxy(controller)
        )
        
        controller.onConfirm = adapter.load
        controller.onFinish = onFinish
    
        return controller
    }
}

final class EraseViewControllerAdapter: InteractorResourceView {
    
    private weak var controller: EraserViewController?
    
    init(controller: EraserViewController) {
        self.controller = controller
    }
    
    func display(viewModel: Void) {
        controller?.onFinish?()
    }
}
