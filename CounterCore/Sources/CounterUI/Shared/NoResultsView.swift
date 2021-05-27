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

public final class CounterStarterView: UIView {
    
    private(set) lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Layout.Stack.spacing
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFontMetrics(forTextStyle: .title1).scaledFont(for: Layout.Title.font)
        label.textColor = Layout.Title.color
        label.textAlignment = .center
        label.attributedText = .init(
            string: "No counters yet",
            attributes: [.kern: Layout.Title.kern]
        )
        return label
    }()
    
    private(set) lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: Layout.Detail.font)
        label.textColor = Layout.Detail.color
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        
        let text = """
        “When I started counting my blessings, my whole life turned around.”
        —Willie Nelson
        """
        
        label.attributedText = .init(
            string: text,
            attributes: [.kern: Layout.Detail.kern]
        )
        
        return label
    }()
    
    private(set) lazy var createButton: PrimaryButton = {
        let button = PrimaryButton(title: "Create a counter")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapOnCreateButton), for: .touchUpInside)
        return button
    }()
    
    public var onCreate: (() -> Void)?
    
    // MARK: - Initialization
    
    public init() {
        super.init(frame: .zero)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Actions
    
    @objc private func didTapOnCreateButton(_ sender: PrimaryButton) {
        onCreate?()
    }
}

extension CounterStarterView: ViewConfiguration {
    
    public func setupHierarchy() {
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(detailLabel)
        stackView.addArrangedSubview(createButton)
    }
    
    public func setupConstraints() {
        let stack = [
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Layout.Stack.left),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Layout.Stack.right)
        ]

        let button = [
            createButton.widthAnchor.constraint(equalToConstant: Layout.Button.width),
            createButton.heightAnchor.constraint(equalToConstant: Layout.Button.height)
        ]
        
        button.forEach { $0.priority = .init(999) }
        
        NSLayoutConstraint.activate([stack, button].reduce([], +))
    }
}

private extension CounterStarterView {
    
    enum Layout {
        
        enum Stack {
            static let spacing: CGFloat = 20
            static let left: CGFloat = 35
            static let right: CGFloat = -35
        }
         
        enum Title {
            static let font: UIFont = .systemFont(ofSize: 22, weight: .semibold)
            static let color: UIColor = .label
            static let kern: CGFloat = 0.44
        }
        
        enum Detail {
            static let font: UIFont = .systemFont(ofSize: 17, weight: .regular)
            static let color: UIColor = .secondaryLabel
            static let kern: CGFloat = 0.34
        }
        
        enum Button {
            static let height: CGFloat = 35
            static let width: CGFloat = 175
        }
    }
}
