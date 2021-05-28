//
//  ExampleCountersPresenter.swift
//  Counters
//
//  Created by Thales Frigo on 27/05/21.
//

import Foundation

final class ExampleCountersPresenter: ExampleCountersViewControllerPresenter {
    
    var title: String {
        return "Examples"
    }
    
    var viewModel: ExampleCountersViewModel {
        return .init(
            hint: "Select an example to add it to your counters.",
            categories: [
                .init(
                    category: "Drinks",
                    items: [
                        .init(name: "Cups of coffee"),
                        .init(name: "Glasses of water"),
                        .init(name: "Shots of vodka"),
                    ]
                ),
                .init(
                    category: "Food",
                    items: [
                        .init(name: "Hot-dogs"),
                        .init(name: "Cupcakes eaten"),
                        .init(name: "Chicken eaten"),
                    ]
                ),
                .init(
                    category: "Misc",
                    items: [
                        .init(name: "Naps"),
                        .init(name: "Cupcakes eaten"),
                        .init(name: "Day dreaming"),
                    ]
                ),
            ]
        )
    }
}
