//
//  PrimaryButton.swift
//  
//
//  Created by Thales Frigo on 26/05/21.
//

import UIKit

final class PrimaryButton: UIButton {

    // MARK: - Properties

    override var isEnabled: Bool {
        get { super.isEnabled }
        set {
            backgroundColor = newValue ? ColorConstants.accentColor : ColorConstants.disabledColor
            super.isEnabled = newValue
        }
    }

    override var isHighlighted: Bool {
        get { super.isHighlighted }
        set {
            alpha = newValue ? 0.8 : 1
            super.isHighlighted = newValue
        }
    }

    // MARK: - Initialization

    init() {
        super.init(frame: .zero)
        configureUI()
    }

    convenience init(title: String) {
        self.init()
        self.setTitle(title, for: .normal)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Internal Methods
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        guard let title = title else {
            return super.setTitle(nil, for: state)
        }
        setAttributedTitle(.init(string: title, attributes: [.kern: Font.kern]), for: state)
    }
}

// MARK: - Private definitions

private extension PrimaryButton {

    enum ColorConstants {
        static let accentColor = UIColor(red: 1, green: 0.584, blue: 0, alpha: 1)
        static let textColor = UIColor.white
        static let disabledColor = accentColor.withAlphaComponent(0.5)
    }

    enum LayoutConstants {
        static let cornerRadius: CGFloat = 8.0
        static let edgeInsets: CGFloat = 8.0
    }
    
    enum Font {
        static let kern: CGFloat = 0.51
        static let title = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }

    func configureUI() {
        contentEdgeInsets = UIEdgeInsets(top: LayoutConstants.edgeInsets,
                                         left: LayoutConstants.edgeInsets,
                                         bottom: LayoutConstants.edgeInsets,
                                         right: LayoutConstants.edgeInsets)
        layer.cornerRadius = LayoutConstants.cornerRadius
        backgroundColor = ColorConstants.accentColor
        setTitleColor(ColorConstants.textColor, for: .normal)
        titleLabel?.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: Font.title)
    }
}

