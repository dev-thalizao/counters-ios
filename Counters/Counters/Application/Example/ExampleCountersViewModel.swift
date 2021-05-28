//
//  ExampleCountersViewModel.swift
//  Counters
//
//  Created by Thales Frigo on 27/05/21.
//

import Foundation

struct ExampleCountersViewModel: Hashable {
    let hint: String
    let categories: [ExampleCategoryViewModel]
}

struct ExampleCategoryViewModel: Hashable {
    let category: String
    let items: [ExampleCounterViewModel]
}

struct ExampleCounterViewModel: Hashable {
    let name: String
}
