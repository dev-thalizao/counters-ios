//
//  ExampleCountersUIComposer.swift
//  Counters
//
//  Created by Thales Frigo on 27/05/21.
//

import UIKit

final class ExampleCountersUIComposer {
    
    private init() {}
    
    static func examplesComposedWith(
        onSelect: @escaping (ExampleCounterViewModel) -> Void
    ) -> UIViewController {
        let exampleVC = ExampleCountersViewController(
            presenter: ExampleCountersPresenter()
        )
        exampleVC.onSelect = onSelect
        return exampleVC
    }
}
