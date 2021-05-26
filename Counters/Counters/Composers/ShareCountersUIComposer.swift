//
//  ShareCountersUIComposer.swift
//  Counters
//
//  Created by Thales Frigo on 26/05/21.
//

import UIKit
import CounterCore
import CounterPresentation

public final class ShareCountersUIComposer {
    
    private init() {}
    
    public static func shareComposedWith(_ counters: [Counter]) -> UIViewController {
        return UIActivityViewController(
            activityItems: [SharePresenter.map(counters).description],
            applicationActivities: nil
        )
    }
}
