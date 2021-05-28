//
//  ExampleCounterTableCell.swift
//  Counters
//
//  Created by Thales Frigo on 27/05/21.
//

import UIKit
import CounterUI

final class ExampleCounterTableCell: UITableViewCell {
    typealias OnSelection = (ExampleCounterViewModel) -> Void
    
    private(set) lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.headerReferenceSize = .zero
        layout.footerReferenceSize = .zero
        layout.estimatedItemSize = .init(width: 150, height: 55)
        layout.sectionInset = .init(top: 10, left: 15, bottom: 20, right: 15)
        return layout
    }()
    
    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ExampleCounterCollectionCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemGroupedBackground
        return collectionView
    }()
    
    private lazy var items = [ExampleCounterViewModel]()
    
    var onSelection: OnSelection?
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Public Methods

    public func configure(with items: [ExampleCounterViewModel]) {
        self.items = items
        collectionView.reloadData()
    }
}

// MARK: - ViewConfiguration Methods

extension ExampleCounterTableCell: ViewConfiguration {
    
    func setupHierarchy() {
        contentView.addSubview(collectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func setupViews() {
        contentView.backgroundColor = .systemGroupedBackground
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegateFlowLayout Methods

extension ExampleCounterTableCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as ExampleCounterCollectionCell
        let item = items[indexPath.item]
        
        cell.configure(with: item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        onSelection?(item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = items[indexPath.item]
        return .init(width: item.name.width() + 55, height: 55)
    }
}

private extension String {
    
    func width() -> CGFloat {
        let label = UILabel()
        label.text = self
        label.sizeToFit()
        
        return label.frame.width
    }
}
