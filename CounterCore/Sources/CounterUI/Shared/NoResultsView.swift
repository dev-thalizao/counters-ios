//
//  NoResultsView.swift
//  
//
//  Created by Thales Frigo on 26/05/21.
//

import UIKit

public final class NoResultsView: UIView {
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFontMetrics(forTextStyle: .title1).scaledFont(for: Layout.Title.font)
        label.textColor = Layout.Title.color
        label.textAlignment = .center
        label.attributedText = .init(
            string: "No results",
            attributes: [.kern: Layout.Title.kern]
        )
        return label
    }()
    
    // MARK: - Initialization
    
    public init() {
        super.init(frame: .zero)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
}

// MARK: - ViewConfiguration Methods

extension NoResultsView: ViewConfiguration {
    
    public func setupHierarchy() {
        addSubview(titleLabel)
    }
    
    public func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Layout.Title.left),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Layout.Title.right)
        ])
    }
}

// MARK: - Layout Constants

private extension NoResultsView {
    
    enum Layout {
        
        enum Title {
            static let font: UIFont = .systemFont(ofSize: 20, weight: .regular)
            static let color: UIColor = .secondaryLabel
            static let kern: CGFloat = 0.6
            static let left: CGFloat = 35
            static let right: CGFloat = -35
        }
    }
}
