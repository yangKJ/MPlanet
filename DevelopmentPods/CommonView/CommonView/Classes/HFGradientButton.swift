//
//  HFGradientButton.swift
//  FeatBox
//
//  Created by Condy on 2022/4/25.
//

import Foundation

/// 渐变按钮
open class HFGradientButton: UIButton {
    private let gradientLayer = CAGradientLayer()
    private let highlightLayer = CALayer()
    private let cornerLayer = CAShapeLayer()
    
    public var colors: [CGColor]? {
        didSet {
            if oldValue == colors {
                return
            }
            gradientLayer.colors = isEnabled ? colors : [UIColor.lightGray.cgColor, UIColor.lightGray.cgColor]
        }
    }
    
    public var cornerRadiusWithShadow: CGFloat = 0
    
    public var needShadow: Bool = true {
        didSet {
            if oldValue == needShadow {
                return
            }
            if needShadow {
                gradientLayer.shadowOpacity = 0.3
            } else {
                gradientLayer.shadowOpacity = 0
            }
        }
    }
    
    public var roundingCorners: UIRectCorner = [.topLeft, .topRight, .bottomLeft, .bottomRight] {
        didSet {
            if oldValue == roundingCorners {
                return
            }
            layoutSubviews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.mask = cornerLayer
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.8)
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.colors = colors
        gradientLayer.shadowOffset = CGSize(width: 0, height: 3.0)
        gradientLayer.shadowOpacity = 0.3
        gradientLayer.shadowRadius = 5
        gradientLayer.shadowColor = UIColor.black.cgColor
        self.layer.addSublayer(gradientLayer)
        
        highlightLayer.backgroundColor = UIColor.black.cgColor
        highlightLayer.opacity = 0.3
        highlightLayer.isHidden = !isHighlighted
        self.layer.addSublayer(highlightLayer)
    }
    
    public override var isHighlighted: Bool {
        didSet {
            if oldValue == isHighlighted {
                return
            }
            highlightLayer.isHidden = !isHighlighted
        }
    }
    
    public override var isEnabled: Bool {
        didSet {
            if oldValue == isEnabled {
                return
            }
            gradientLayer.colors = isEnabled ? colors : [UIColor.lightGray.cgColor, UIColor.lightGray.cgColor]
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        highlightLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        
        let maskPath = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: roundingCorners,
                                    cornerRadii: CGSize(width: cornerRadiusWithShadow, height: cornerRadiusWithShadow))
        cornerLayer.path = maskPath.cgPath
        cornerLayer.frame = self.bounds
    }
}
