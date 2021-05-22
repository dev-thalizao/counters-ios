//
//  File.swift
//  
//
//  Created by Thales Frigo on 22/05/21.
//

import UIKit

public extension CGRect {
    
    func center() -> CGPoint {
        let x = size.width / 2
        let y = size.height / 2
        
        return CGPoint(x: x, y: y)
    }
}
