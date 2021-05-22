//
//  ViewConfiguration.swift
//  
//
//  Created by Thales Frigo on 22/05/21.
//

import UIKit

public protocol ViewConfiguration {
    func setupHierarchy()
    func setupConstraints()
    func setupViews()
}

public extension ViewConfiguration {
    
    func setup() {
        setupHierarchy()
        setupConstraints()
        setupViews()
    }
    
    func setupConstraints() {}
    
    func setupViews() {}
}

public class ViewConfigurationController<View: UIView & ViewConfiguration>: UIViewController {
    
    public var contentView: View {
        return view as! View
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func loadView() {
        view = View()
    }
}
