//
//  WelcomeView.swift
//  Counters
//
//

import UIKit

internal final class WelcomeView: UIView {
    // MARK: - View Model

    struct ViewModel {
        let title: NSAttributedString
        let description: String
        let features: [WelcomeFeatureView.ViewModel]
        let buttonTitle: String
    }
    
    // MARK: - Properties

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let stackView = UIStackView()
    private let button = Button()

    // MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    func configure(with viewModel: ViewModel) {
        titleLabel.attributedText = viewModel.title
        subtitleLabel.attributedText = .init(string: viewModel.description,
                                                attributes: [.kern: Font.kern])
        
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        viewModel.features.forEach {
            let view = WelcomeFeatureView()
            view.configure(with: $0)
            stackView.addArrangedSubview(view)
        }
        
        button.setTitle(viewModel.buttonTitle, for: .normal)
    }
}

// MARK: - Private Constants

private extension WelcomeView {
    enum Constants {
        static let spacing: CGFloat = 24
        static let buttonHeight: CGFloat = 57
        static let stackViewTopMargin: CGFloat = 45
    }
    
    enum Font {
        static let kern: CGFloat = 0.34
        static let title = UIFont.systemFont(ofSize: 33, weight: .heavy)
        static let description = UIFont.systemFont(ofSize: 17, weight: .regular)
    }
    
    enum Shadow {
        static let opacity: Float = 1
        static let radius: CGFloat = 16
        static let offset = CGSize(width: 0, height: 8)
        static let color = UIColor(white: 0, alpha: 0.1).cgColor
    }
}

// MARK: - Private Implementation

private extension WelcomeView {
    func setup() {
        backgroundColor = .systemBackground

        setupTitleLabel()
        setupSubtitleLabel()
        setupStackView()
        setupButton()
        setupViewHierarchy()
        setupConstraints()
    }
    
    func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: Font.title)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        if #available(iOS 14.0, *) {
            /// used to leave the `Counters` as an Orphaned Word
            titleLabel.lineBreakStrategy = .hangulWordPriority
        }
    }
    
    func setupSubtitleLabel() {
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: Font.description)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textColor = UIColor(named: "SubtitleText")
    }
    
    func setupStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Constants.spacing
        stackView.alignment = .top
    }
    
    func setupButton() {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didPressContinue), for: .touchUpInside)
        
        button.clipsToBounds = false
        button.layer.shadowRadius = Shadow.radius
        button.layer.shadowColor = Shadow.color
        button.layer.shadowOffset = Shadow.offset
        button.layer.shadowOpacity = Shadow.opacity
    }
    
    func setupViewHierarchy() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(stackView)
        addSubview(button)
    }
    
    func setupConstraints() {
        let guide = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            // title label
            titleLabel.topAnchor.constraint(equalTo: guide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            
            // subtitle label
            subtitleLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: Constants.spacing
            ),
            subtitleLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            
            // stack view
            stackView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            stackView.topAnchor.constraint(
                equalTo: subtitleLabel.bottomAnchor,
                constant: Constants.stackViewTopMargin
            ),
            // button
            button.heightAnchor.constraint(
                greaterThanOrEqualToConstant: Constants.buttonHeight
            ),
            button.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ])
    }
}

private extension WelcomeView {
    @objc func didPressContinue() {
        
    }
}
