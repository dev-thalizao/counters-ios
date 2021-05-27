//
//  AppDelegate.swift
//  Counters
//
//

import os
import UIKit
import CoreData
import CounterCore
import CounterStore
import CounterPresentation
import CounterUI

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    @available(iOS 14.0, *)
    private lazy var logger = Logger(subsystem: "com.cornershop.Counters", category: "main")
    
    private lazy var store: CounterStore = {
        do {
            return try CoreDataCounterStore(
                storeURL: NSPersistentContainer
                    .defaultDirectoryURL()
                    .appendingPathComponent("counter-store.sqlite")
            )
        } catch {
            assertionFailure("Failed to instantiate CoreData store with error: \(error.localizedDescription)")
        
            if #available(iOS 14, *) {
                logger.fault("Failed to instantiate CoreData store with error: \(error.localizedDescription)")
            }
            
            return NullStore()
        }
    }()
    
    private lazy var counterLoader: CounterLoader = {
        return MainQueueDispatchDecorator(
            decoratee: LocalCounterLoader(store: store)
        )
    }()
    
    private lazy var counterCreator: CounterCreator = {
        return MainQueueDispatchDecorator(
            decoratee: LocalCounterCreator(store: store)
        )
    }()
    
    private lazy var counterIncrementer: CounterIncrementer = {
        return MainQueueDispatchDecorator(
            decoratee: LocalCounterIncrementer(store: store)
        )
    }()
    
    private lazy var counterDecrementer: CounterDecrementer = {
        return MainQueueDispatchDecorator(
            decoratee: LocalCounterDecrementer(store: store)
        )
    }()
    
    private lazy var counterEraser: CounterEraser = {
        return MainQueueDispatchDecorator(
            decoratee: LocalCounterEraser(store: store)
        )
    }()
    
    private lazy var navigationController: UINavigationController = {
        let navigationController = UINavigationController(
            rootViewController: LoadCountersUIComposer.counterComposedWith(
                counterLoader: counterLoader,
                counterIncrementer: counterIncrementer,
                counterDecrementer: counterDecrementer,
                onAdd: showCreation,
                onErase: showEraser,
                onShare: showShare
            )
        )
        navigationController.view.backgroundColor = .systemBackground
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.isToolbarHidden = false
        return navigationController
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow()
//        let presenter = WelcomeViewPresenter()
//        window.rootViewController = WelcomeViewController(presenter: presenter)
        
//        window.rootViewController = PrototypeComposer.prototype()
        window.rootViewController = navigationController
        
        self.window = window
        window.makeKeyAndVisible()
        return true
    }
    
    private func showCreation() {
        let idGenerator: () -> Counter.ID = {
            return UUID().uuidString
        }
        
        let createVC = CreateCounterUIComposer.createComposedWith(
            idGenerator: idGenerator,
            counterCreator: counterCreator,
            onFinish: { [navigationController] in
                $0.dismiss(animated: true) {
                    navigationController.topViewController?.viewWillAppear(true)
                }
            }
        )
        
        let createNC = UINavigationController(
            rootViewController: createVC
        )
        
        navigationController.present(createNC, animated: true)
    }
    
    private func showEraser(_ counters: [Counter]) {
        let eraserVC = EraseCountersUIComposer.eraseComposedWith(
            counters: counters,
            counterEraser: counterEraser,
            onFinish: { [navigationController] in
                $0.dismiss(animated: true) {
                    navigationController.topViewController?.viewWillAppear(true)
                }
            }
        )
        
        eraserVC.modalPresentationStyle = .overFullScreen
        eraserVC.modalTransitionStyle = .crossDissolve
        
        navigationController.present(eraserVC, animated: false)
    }
    
    private func showShare(_ counters: [Counter]) {
        navigationController.present(
            ShareCountersUIComposer.shareComposedWith(counters),
            animated: true
        )
    }
}
