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
import CounterAPI
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
    
    private lazy var client: HTTPClient = {
        return URLSessionHTTPClient(session: .init(configuration: .ephemeral))
    }()
    
    private lazy var counterLoader: CounterLoader = {
        let remote = RemoteCounterLoader(client: client)
        let local = LocalCounterLoader(store: store)
        
        let decorated = FallbackCounterLoaderDecorator(
            decoratee: CacheCounterLoaderDecorator(
                decoratee: remote,
                cache: local
            ),
            fallback: local
        )
        
        return MainQueueDispatchDecorator(
            decoratee: decorated
        )
    }()
    
    private lazy var counterCreator: CounterCreator = {
        return MainQueueDispatchDecorator(
            decoratee: RemoteCounterCreator(client: client)
        )
    }()
    
    private lazy var counterIncrementer: CounterIncrementer = {
        return MainQueueDispatchDecorator(
            decoratee: RemoteCounterIncrementer(client: client)
        )
    }()
    
    private lazy var counterDecrementer: CounterDecrementer = {
        return MainQueueDispatchDecorator(
            decoratee: RemoteCounterDecrementer(client: client)
        )
    }()
    
    private lazy var counterEraser: CounterEraser = {
        return MainQueueDispatchDecorator(
            decoratee: RemoteCounterEraser(client: client)
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
        navigationController.delegate = self
        return navigationController
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        window.rootViewController = navigationController
        window.tintColor = UIColor(named: "AccentColor")!
        
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
            onFinish: { controller in
                controller.dismiss(animated: true)
            },
            onSeeExamples: { controller, input in
                let exampleVC = ExampleCountersUIComposer.examplesComposedWith { [input] controller, selected in
                    input(selected.name)
                    controller.navigationController?.popViewController(animated: true)
                }
                controller.show(exampleVC, sender: nil)
            }
        )
        
        let createNC = UINavigationController(
            rootViewController: createVC
        )
        createNC.navigationBar.prefersLargeTitles = true
        createNC.modalPresentationStyle = .fullScreen
        
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

extension AppDelegate: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard let counterViewController = viewController as? CountersViewController else { return }
        
        if UserDefaults.standard.userShouldOnboard() {
            let welcomeVC = WelcomeCountersUIComposer.welcomeComposedWith {
                $0.dismiss(animated: true) {
                    UserDefaults.standard.userDidOnboard()
                }
            }
            
            counterViewController.present(welcomeVC, animated: true)
        }
    }
}
