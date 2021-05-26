//
//  CounterView.swift
//  
//
//  Created by Thales Frigo on 21/05/21.
//

import UIKit
import CounterPresentation

final class CounterView: UIView {
    
    // MARK: - Properties
    
    private(set) lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Layout.Counter.color
        label.font = UIFontMetrics(forTextStyle: .title1).scaledFont(for: Layout.Counter.font)
        label.textAlignment = .right
        return label
    }()
    
    private(set) lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Layout.Separator.color
        return view
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFontMetrics(forTextStyle: .title2).scaledFont(for: Layout.Title.font)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private(set) lazy var counterStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.addTarget(self, action: #selector(didTapOnStepper(_:)), for: .valueChanged)
        return stepper
    }()
    
    var onCounterStepperChanged: (Int) -> Void = { _ in }
    
    private lazy var shapeLayer = CAShapeLayer()
    
    private lazy var shadowLayer: CALayer = {
        let contentLayer = CALayer()
        contentLayer.shadowColor = Layout.Shadow.color
        contentLayer.shadowOpacity = Layout.Shadow.opacity
        contentLayer.shadowRadius = Layout.Shadow.radius
        contentLayer.shadowOffset = Layout.Shadow.offset
        return contentLayer
    }()
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayers()
    }
    
    // MARK: - Actions
    
    @objc private func didTapOnStepper(_ stepper: UIStepper) {
        onCounterStepperChanged(Int(stepper.value))
    }
    
    // MARK: - Configuration
    
    public func configure(with viewModel: CounterViewModel) {
        counterLabel.attributedText = .init(
            string: viewModel.count,
            attributes: [.kern: Layout.Counter.kern]
        )
        titleLabel.attributedText = .init(
            string: viewModel.title,
            attributes: [.kern: Layout.Title.kern]
        )
        
        counterStepper.value = Double(viewModel.count) ?? 0
        counterStepper.minimumValue = 0
    }
}

// MARK: - ViewConfiguration Methods

extension CounterView: ViewConfiguration {
    
    func setupHierarchy() {
        addSubview(counterLabel)
        addSubview(separatorView)
        addSubview(titleLabel)
        addSubview(counterStepper)
    }
    
    func setupConstraints() {
        let counter = [
            counterLabel.topAnchor.constraint(equalTo: topAnchor, constant: Layout.Counter.top),
            counterLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Layout.Counter.left),
            counterLabel.trailingAnchor.constraint(equalTo: separatorView.leadingAnchor, constant: Layout.Counter.right)
        ]
        
        let separator = [
            separatorView.topAnchor.constraint(equalTo: topAnchor),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Layout.Separator.left),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.widthAnchor.constraint(equalToConstant: Layout.Separator.width)
        ]
        
        let title = [
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Layout.Title.top),
            titleLabel.leadingAnchor.constraint(equalTo: separatorView.trailingAnchor, constant: Layout.Title.left),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Layout.Title.bottom),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Layout.Title.right),
        ]
        
        let stepper = [
            counterStepper.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Layout.Stepper.bottom),
            counterStepper.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Layout.Stepper.right)
        ]
        
        NSLayoutConstraint.activate(
            [counter, separator, title, stepper].reduce([], +)
        )
    }
    
    func setupViews() {
        clipsToBounds = false
        
        layer.insertSublayer(shadowLayer, at: 0)
        layer.insertSublayer(shapeLayer, at: 1)
        
        shapeLayer.fillColor = Layout.Root.color
    }
    
    func setupLayers() {
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: Layout.Root.radius)
    
        shadowLayer.shadowPath = path.cgPath
        shadowLayer.bounds = bounds
        shadowLayer.position = bounds.center()
        
        shapeLayer.path = path.cgPath
        shapeLayer.bounds = bounds
        shapeLayer.position = bounds.center()
    }
}

// MARK: - Layout Constants

private extension CounterView {
    
    enum Layout {
        
        enum Root {
            static let radius: CGFloat = 8
            static let color = UIColor.systemBackground.cgColor
        }
    
        enum Counter {
            static let top: CGFloat = 15
            static let left: CGFloat = 14
            static let right: CGFloat = -10
            static let font: UIFont = .systemFont(ofSize: 24, weight: .semibold)
            static let kern: CGFloat = -0.41
            static let paragraph: CGFloat = 0.77
            static let color = UIColor(named: "AccentColor")
        }
        
        enum Separator {
            static let width: CGFloat = 2
            static let left: CGFloat = 59
            static let color = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1)
        }
        
        enum Title {
            static let top: CGFloat = 16
            static let left: CGFloat = 10
            static let bottom: CGFloat = -60
            static let right: CGFloat = -14
            static let font: UIFont = .systemFont(ofSize: 17, weight: .regular)
            static let kern: CGFloat = 0.34
        }
        
        enum Stepper {
            static let bottom: CGFloat = -14
            static let right: CGFloat = -14
        }
        
        enum Shadow {
            static let opacity: Float = 1
            static let radius: CGFloat = 16 // B
            static let offset = CGSize(width: 0, height: 4) // X, Y
            static let color = UIColor(white: 0, alpha: 0.02).cgColor // Color, Opacity
        }
    }
}
