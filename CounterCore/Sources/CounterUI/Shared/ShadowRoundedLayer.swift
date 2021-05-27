//
//  ShadowRoundedLayer.swift
//  
//
//  Created by Thales Frigo on 22/05/21.
//

import UIKit

final class ShadowRoundedLayer: CALayer {
    
    private(set) lazy var shapeLayer = CAShapeLayer()
    
    private(set) lazy var shadowLayer: CALayer = {
        let contentLayer = CALayer()
        contentLayer.shadowColor = Layout.Shadow.color.cgColor
        contentLayer.shadowOpacity = Layout.Shadow.opacity
        contentLayer.shadowRadius = Layout.Shadow.radius
        contentLayer.shadowOffset = Layout.Shadow.offset
        return contentLayer
    }()
    
    override init() {
        super.init()
        addSublayer(shadowLayer)
        addSublayer(shapeLayer)
    }
    
    required init?(coder: NSCoder) { nil }
    
    func draw(using view: UIView) {
        let bounds = view.bounds
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: Layout.Shape.radius)
    
        shadowLayer.shadowPath = path.cgPath
        shadowLayer.bounds = bounds
        shadowLayer.position = bounds.center()
        
        shapeLayer.path = path.cgPath
        shapeLayer.bounds = bounds
        shapeLayer.position = bounds.center()
        shapeLayer.fillColor = Layout.Shape.color.cgColor
    }
}

private extension ShadowRoundedLayer {
    
    enum Layout {
        
        enum Shape {
            static let radius: CGFloat = 8
            static let color: UIColor = .secondarySystemGroupedBackground
        }
        
        enum Shadow {
            static let opacity: Float = 1
            static let radius: CGFloat = 16 // B
            static let offset: CGSize = .init(width: 0, height: 4) // X, Y
            static let color: UIColor = .init(white: 0, alpha: 0.08) // Color, Opacity
        }
    }
}
