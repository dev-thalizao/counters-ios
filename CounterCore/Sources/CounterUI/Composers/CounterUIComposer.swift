//
//  CounterUIComposer.swift
//  
//
//  Created by Thales Frigo on 22/05/21.
//

import UIKit
import CounterCore
import CounterPresentation

private typealias LoaderPresentationAdapter = InteractorLoaderPresentationAdapter<[Counter], LoadViewAdapter>
private typealias IncrementerPresentationAdapter = InteractorLoaderPresentationAdapter<CounterViewModel, WeakRefVirtualProxy<CounterCellController>>
private typealias DecrementerPresentationAdapter = InteractorLoaderPresentationAdapter<CounterViewModel, WeakRefVirtualProxy<CounterCellController>>
private typealias EraserPresentationAdapter = InteractorLoaderPresentationAdapter<Void, EraseViewAdapter>

public final class CounterUIComposer {

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

private typealias CounterPresentationAdapter = InteractorLoaderPresentationAdapter<Counter, CounterViewAdapter>

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
        controller?.onErase = onEraseAdapter
        controller?.onShare = onShareAdapter
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

public final class EraseCounterUIComposer {
    
    private typealias PresentationAdapter = InteractorLoaderPresentationAdapter<Void, EraseViewControllerAdapter>
    
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

final class EraserViewController: UIViewController {
    
    var onConfirm: (() -> Void)?
    var onFinish: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red.withAlphaComponent(0.6)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertVC.addAction(.init(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.onConfirm?()
        }))
        alertVC.addAction(.init(title: "Cancel", style: .cancel, handler: { [weak self] _ in
            self?.onFinish?()
        }))
        
        present(alertVC, animated: true)
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

extension EraserViewController: InteractorErrorView {

    func display(viewModel: InteractorErrorViewModel) {
        // add child loading
    }
}

extension EraserViewController: InteractorLoadingView {
    
    func display(viewModel: InteractorLoadingViewModel) {
        // add child error
    }
}
    
public final class ShareUIComposer {
    
    private init() {}
    
    public static func shareComposedWith(_ counters: [Counter]) -> UIViewController {
        return UIActivityViewController(
            activityItems: [CounterSharePresenter.map(counters).description],
            applicationActivities: nil
        )
    }
}

public struct CounterShareViewModel {
    public let items: [CounterShareItemViewModel]
    
    public var description: String {
        return items.map(\.item).joined(separator: "\n")
    }
}

public struct CounterShareItemViewModel {
    public let item: String
}

public struct CounterSharePresenter {
    
    public static func map(_ counters: [Counter]) -> CounterShareViewModel {
        return .init(items: counters.map(CounterShareItemPresenter.map))
    }
}

public struct CounterShareItemPresenter {
    
    public static func map(_ counter: Counter) -> CounterShareItemViewModel {
        return .init(item: "\(counter.count)x \(counter.title)")
    }
}
