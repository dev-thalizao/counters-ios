//
//  CreateCounterView.swift
//  
//
//  Created by Thales Frigo on 22/05/21.
//

import UIKit

protocol CreateCounterViewDelegate: AnyObject {
    func createCounterViewDidCancel(_ createCounterView: CreateCounterView)
    func createCounterView(_ createCounterView: CreateCounterView, didSelectName name: String)
}

final class CreateCounterView: UIView {
    
    private(set) lazy var cancelButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapOnCancelButton(_:)))
        return barButton
    }()
    
    private(set) lazy var saveButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapOnSaveButton(_:)))
        barButton.isEnabled = false
        return barButton
    }()
    
    private(set) lazy var textField: UITextField = {
        let textField = PaddingTextField(padding: Layout.TextField.padding)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Cups of coffee"
        textField.font = Layout.TextField.font
        textField.borderStyle = .none
        textField.addTarget(self, action: #selector(textDidChanged(_:)), for: .editingChanged)
        return textField
    }()
    
    private(set) lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    private(set) lazy var hintTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = Layout.HintText.background
        textView.font = Layout.HintText.font
        textView.textColor = Layout.HintText.color
        textView.attributedText = .init(string: "Give it a name. Creative block? See examples.", attributes: [.kern: 0.3])
        textView.isScrollEnabled = false
        textView.isSelectable = false
        textView.isEditable = false
        return textView
    }()
    
    private(set) lazy var shadowRoundedLayer = ShadowRoundedLayer()
    
    weak var delegate: CreateCounterViewDelegate?
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Lifecycle Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowRoundedLayer.draw(using: textField)
    }
    
    // MARK: - Actions
    
    @objc private func didTapOnCancelButton(_ sender: UIBarButtonItem) {
        delegate?.createCounterViewDidCancel(self)
    }
    
    @objc private func didTapOnSaveButton(_ sender: UIBarButtonItem) {
        guard let name = textField.text else { return }
        delegate?.createCounterView(self, didSelectName: name)
    }
    
    @objc private func textDidChanged(_ textField: UITextField) {
        print(#function)
        saveButton.isEnabled = textField.text.map(\.isEmpty).map({ !$0 }) ?? false
    }
}

extension CreateCounterView: ViewConfiguration {
    
    func setupHierarchy() {
        addSubview(textField)
        addSubview(activityIndicator)
        addSubview(hintTextView)
        textField.layer.addSublayer(shadowRoundedLayer)
    }
    
    func setupConstraints() {
        let guide = safeAreaLayoutGuide
        
        let input = [
            textField.topAnchor.constraint(equalTo: guide.topAnchor, constant: Layout.TextField.top),
            textField.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: Layout.TextField.left),
            textField.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: Layout.TextField.right)
        ]
        
        let loader = [
            activityIndicator.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: Layout.ActivityIndicator.right),
            activityIndicator.centerYAnchor.constraint(equalTo: textField.centerYAnchor)
        ]
        
        let hint = [
            hintTextView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: Layout.HintText.top),
            hintTextView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: Layout.HintText.left),
            hintTextView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: Layout.HintText.right)
        ]
        
        NSLayoutConstraint.activate(
            [input, loader, hint].reduce([], +)
        )
    }
    
    func setupViews() {
        backgroundColor = Layout.Root.color
    }
}

private extension CreateCounterView {
    
    enum Layout {
        
        enum Root {
            static let color = UIColor.systemGroupedBackground
        }
        
        enum TextField {
            static let top = CGFloat(25)
            static let left = CGFloat(12)
            static let right = CGFloat(-12)
            static let padding = UIEdgeInsets(top: 17, left: 17, bottom: 18, right: 54)
            static let font = UIFontMetrics(forTextStyle: .body).scaledFont(for: .systemFont(ofSize: 17, weight: .regular))
        }
        
        enum ActivityIndicator {
            static let right = CGFloat(-17)
        }
        
        enum HintText {
            static let top = CGFloat(12)
            static let left = CGFloat(24)
            static let right = CGFloat(-24)
            static let background = UIColor.clear
            static let font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: .systemFont(ofSize: 15, weight: .regular))
            static let color = UIColor.tertiaryLabel
        }
    }
}
