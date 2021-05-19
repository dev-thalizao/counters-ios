//
//  WelcomeFeatureView.swift
//  Counters
//
//

import UIKit

internal final class WelcomeFeatureView: UIView {
    
    // MARK: - View Model

    struct ViewModel: Hashable {
        let badge: UIImage?
        let title: String
        let subtitle: String
    }
    
    // MARK: - Properties
    
    private let badgeImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
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
        badgeImageView.image = viewModel.badge
        titleLabel.attributedText = .init(string: viewModel.title, attributes: [.kern: Font.kern])
        descriptionLabel.attributedText = .init(string: viewModel.subtitle, attributes: [.kern: Font.kern])
    }
}
// MARK: - Constants

private extension WelcomeFeatureView {
    enum Constants {
        static let imageWidth: CGFloat = 49
        static let horizontalSpacing: CGFloat = 15
        static let verticalSpacing: CGFloat = 7
    }
    
    enum Font {
        static let kern: CGFloat = 0.34
        static let title = UIFont.systemFont(ofSize: 17, weight: .semibold)
        static let subtitle = UIFont.systemFont(ofSize: 17, weight: .regular)
    }
}

// MARK: - Private Implementation

private extension WelcomeFeatureView {
    func setup() {
        setupBadgeImageView()
        setupTitleLabel()
        setupDescriptionLabel()
        setupHierarchy()
        setupConstraints()
    }
    
    func setupBadgeImageView() {
        badgeImageView.translatesAutoresizingMaskIntoConstraints = false
        badgeImageView.contentMode = .center
    }
    
    func setupTitleLabel() {
        titleLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: Font.title)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byCharWrapping
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupDescriptionLabel() {
        descriptionLabel.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: Font.subtitle)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = UIColor(named: "DescriptionText")
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupHierarchy() {
        addSubview(badgeImageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            badgeImageView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            badgeImageView.topAnchor.constraint(
                equalTo: topAnchor
            ),
            badgeImageView.widthAnchor.constraint(equalToConstant: Constants.imageWidth),
            
            titleLabel.leadingAnchor.constraint(
                equalTo: badgeImageView.trailingAnchor,
                constant: Constants.horizontalSpacing),
            titleLabel.topAnchor.constraint(
                equalTo: topAnchor
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            
            descriptionLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: Constants.verticalSpacing
            ),
            descriptionLabel.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor
            ),
            descriptionLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            descriptionLabel.bottomAnchor.constraint(
                equalTo: bottomAnchor
            )
        ])
    }
}

