//
//  CounterCell.swift
//  
//
//  Created by Thales Frigo on 20/05/21.
//

import UIKit
import CounterPresentation

public final class CounterCell: UITableViewCell {
    
    // MARK: - Properties
    
    private(set) lazy var counterView: CounterView = {
        let counterView = CounterView()
        counterView.translatesAutoresizingMaskIntoConstraints = false
        return counterView
    }()
    
    private var editingValueObservation: NSKeyValueObservation?

    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
//    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    public func configure(with viewModel: CounterViewModel) {
        counterView.configure(with: viewModel)
    }
}

// MARK: - ViewConfiguration Methods

extension CounterCell: ViewConfiguration {
    
    public func setupViews() {
        contentView.backgroundColor = Layout.Root.color
        backgroundColor = Layout.Root.color
        
        editingValueObservation = observe(\.isEditing, options: [.new]) { (object, change) in
            print(object)
            print(change)
        }
    }
    
    public func setupHierarchy() {
        contentView.addSubview(counterView)
    }
    
    public func setupConstraints() {
        NSLayoutConstraint.activate([
            counterView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Layout.Counter.top
            ),
            counterView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Layout.Counter.left
            ),
            counterView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: Layout.Counter.bottom
            ),
            counterView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: Layout.Counter.right
            ),
        ])
    }
}

// MARK: - Layout Constants

private extension CounterCell {
    
    enum Layout {

        enum Root {
            static let color = UIColor.systemGroupedBackground
        }
        
        enum Counter {
            static let top = CGFloat(8)
            static let left: CGFloat = 12
            static let bottom = CGFloat(-8)
            static let right: CGFloat = -12
        }
    }
}
