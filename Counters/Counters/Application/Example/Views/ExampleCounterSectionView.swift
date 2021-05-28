//
//  ExampleCounterSectionView.swift
//  Counters
//
//  Created by Thales Frigo on 27/05/21.
//

import UIKit
import CounterUI

final class ExampleCounterSectionView: UIView {
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFontMetrics(forTextStyle: .title3).scaledFont(for: Layout.Title.font)
        label.textColor = Layout.Title.color
        label.textAlignment = .left
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Public Methods
    
    func configure(with section: String) {
        titleLabel.attributedText = .init(
            string: section.uppercased(),
            attributes: [.kern: Layout.Title.kern]
        )
    }
}

// MARK: - ViewConfiguration Methods

extension ExampleCounterSectionView: ViewConfiguration {
    
    func setupHierarchy() {
        addSubview(titleLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: Layout.Title.top),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Layout.Title.left),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Layout.Title.right)
        ])
    }
}

// MARK: - Layout Constants

private extension ExampleCounterSectionView {
    
    enum Layout {
        
        enum Title {
            static let font: UIFont = .systemFont(ofSize: 13, weight: .regular)
            static let color: UIColor = .secondaryLabel
            static let kern: CGFloat = 0.52
            static let top: CGFloat = 8
            static let left: CGFloat = 24
            static let right: CGFloat = -24
        }
    }
}
