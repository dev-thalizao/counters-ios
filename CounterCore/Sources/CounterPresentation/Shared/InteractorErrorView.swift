//
//  InteractorErrorView.swift
//  
//
//  Created by Thales Frigo on 19/05/21.
//

import Foundation

struct InteractorErrorViewModel {
    let reason: String?
}

protocol InteractorErrorView {
    func display(_ viewModel: InteractorErrorViewModel)
}
