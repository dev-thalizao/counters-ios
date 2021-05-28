//
//  ExampleCounterView.swift
//  Counters
//
//  Created by Thales Frigo on 27/05/21.
//

import UIKit
import CounterUI

final class ExampleCounterView: UIView {
    
    private(set) lazy var nameLabel: UILabel = {
        let textField = UILabel()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = Layout.Name.font
        textField.textAlignment = .center
        return textField
    }()
    
    private(set) lazy var shadowRoundedLayer = ShadowRoundedLayer()
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Lifecycle Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowRoundedLayer.draw(using: self)
    }
    
    // MARK: - Public Methods
    
    public func configure(with viewModel: ExampleCounterViewModel) {
        nameLabel.attributedText = .init(
            string: viewModel.name,
            attributes: [.kern: Layout.Name.kern]
        )
    }
}

// MARK: - ViewConfiguration Methods

extension ExampleCounterView: ViewConfiguration {
    
    func setupHierarchy() {
        addSubview(nameLabel)
        layer.insertSublayer(shadowRoundedLayer, at: 0)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: Layout.Name.top),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Layout.Name.left),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Layout.Name.right),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Layout.Name.bottom),
        ])
    }
}

// MARK: - Layout Constants

private extension ExampleCounterView {
    
    enum Layout {
        
        enum Name {
            static let top = CGFloat(17)
            static let left = CGFloat(20)
            static let right = CGFloat(-20)
            static let bottom = CGFloat(-17)
            static let font = UIFontMetrics(forTextStyle: .body).scaledFont(for: .systemFont(ofSize: 17, weight: .regular))
            static let kern: CGFloat = 0.34
        }
    }
}
