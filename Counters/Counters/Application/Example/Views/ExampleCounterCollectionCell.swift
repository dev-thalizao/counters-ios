//
//  ExampleCounterCollectionCell.swift
//  Counters
//
//  Created by Thales Frigo on 27/05/21.
//

import UIKit
import CounterUI

final class ExampleCounterCollectionCell: UICollectionViewCell {
    
    private(set) lazy var exampleCounterView: ExampleCounterView = {
        let exampleCounterView = ExampleCounterView()
        exampleCounterView.translatesAutoresizingMaskIntoConstraints = false
        return exampleCounterView
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Public Methods
    
    public func configure(with viewModel: ExampleCounterViewModel) {
        exampleCounterView.configure(with: viewModel)
    }
}

// MARK: - ViewConfiguration Methods

extension ExampleCounterCollectionCell: ViewConfiguration {
    
    func setupHierarchy() {
        contentView.addSubview(exampleCounterView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            exampleCounterView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Layout.Counter.top
            ),
            exampleCounterView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Layout.Counter.left
            ),
            exampleCounterView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: Layout.Counter.bottom
            ),
            exampleCounterView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: Layout.Counter.right
            ),
        ])
    }
    
    func setupViews() {
        contentView.backgroundColor = Layout.Root.color
    }
}

// MARK: - Layout Constants

private extension ExampleCounterCollectionCell {
    
    enum Layout {

        enum Root {
            static let color = UIColor.systemGroupedBackground
        }
        
        enum Counter {
            static let top: CGFloat     = 2
            static let left: CGFloat    = 4
            static let bottom: CGFloat  = -2
            static let right: CGFloat   = -4
        }
    }
}
