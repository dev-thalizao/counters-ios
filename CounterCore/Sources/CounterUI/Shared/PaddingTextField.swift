//
//  PaddingTextField.swift
//  
//
//  Created by Thales Frigo on 22/05/21.
//

import UIKit

final class PaddingTextField: UITextField {
    
    private let padding: UIEdgeInsets
    
    init(padding: UIEdgeInsets) {
        self.padding = padding
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) { nil }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
