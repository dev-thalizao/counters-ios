//
//  WelcomeCountersUIComposer.swift
//  Counters
//
//  Created by Thales Frigo on 27/05/21.
//

import UIKit

final class WelcomeCountersUIComposer {
    
    private init() {}
    
    static func welcomeComposedWith(
        onFinish: @escaping (UIViewController) -> Void
    ) -> UIViewController {
        let welcomeVC = WelcomeViewController(
            presenter: WelcomeViewPresenter()
        )
        welcomeVC.onFinish = onFinish
        return welcomeVC
    }
}
