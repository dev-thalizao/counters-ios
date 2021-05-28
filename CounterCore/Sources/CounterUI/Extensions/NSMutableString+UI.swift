//
//  NSMutableString+UI.swift
//  
//
//  Created by Thales Frigo on 27/05/21.
//

import UIKit

extension NSMutableAttributedString {
    
    @discardableResult public func setAsLink(_ textToFind: String, url: String, and color: UIColor) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        guard foundRange.location != NSNotFound else {
            return false
        }
        
        addAttribute(.link, value: url, range: foundRange)
        addAttribute(.foregroundColor, value: color, range: foundRange)
        addAttribute(.underlineColor, value: color, range: foundRange)
        addAttribute(.underlineStyle, value: 1, range: foundRange)
        
        return true
    }
}
