//
//  ExampleCounterHintView.swift
//  Counters
//
//  Created by Thales Frigo on 27/05/21.
//

import UIKit
import CounterUI

public final class ExampleCounterHintView: UIView {
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFontMetrics(forTextStyle: .title1).scaledFont(for: Layout.Title.font)
        label.textColor = Layout.Title.color
        label.textAlignment = .center
        return label
    }()
    
    private(set) lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Layout.Separator.color
        return view
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Public Methods
    
    public func configure(with hint: String) {
        titleLabel.attributedText = .init(
            string: hint,
            attributes: [.kern: Layout.Title.kern]
        )
    }
}

// MARK: - ViewConfiguration Methods

extension ExampleCounterHintView: ViewConfiguration {
    
    public func setupHierarchy() {
        addSubview(titleLabel)
        addSubview(separatorView)
    }
    
    public func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Layout.Title.top),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Layout.Title.left),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Layout.Title.bottom),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Layout.Title.right),
            separatorView.heightAnchor.constraint(equalToConstant: Layout.Separator.height),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: - Layout Constants

private extension ExampleCounterHintView {
    
    enum Layout {
        
        enum Root {
            static let color: UIColor = .systemGroupedBackground
        }
        
        enum Separator {
            static let height: CGFloat = 2
            static let color: UIColor = .opaqueSeparator
        }
        
        enum Title {
            static let font: UIFont = .systemFont(ofSize: 15, weight: .regular)
            static let color: UIColor = .secondaryLabel
            static let kern: CGFloat = 0.3
            static let top: CGFloat = 16
            static let left: CGFloat = 16
            static let right: CGFloat = -16
            static let bottom: CGFloat = -16
        }
    }
}
