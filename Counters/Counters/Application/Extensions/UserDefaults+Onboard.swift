//
//  UserDefaults+Onboard.swift
//  Counters
//
//  Created by Thales Frigo on 27/05/21.
//

import Foundation

private extension String {
    static let onboardKey = "onboard"
}

extension UserDefaults {
    
    func userShouldOnboard() -> Bool {
        return !bool(forKey: .onboardKey)
    }
    
    func userDidOnboard() {
        setValue(true, forKey: .onboardKey)
    }
}
