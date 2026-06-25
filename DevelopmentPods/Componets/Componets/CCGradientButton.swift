//
//  CCGradientButton.swift
//  CommonView
//
//  Created by Condy on 2024/5/20.
//

import Foundation

/// 渐变按钮控件
open class CCGradientButton: UIButton {
    
    public var colors: [CGColor]? {
        didSet {
            if oldValue == colors {
                return
            }
            gradientLayer.colors = isEnabled ? colors : notEnabledColors
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
                gradientLayer.shadowOpacity = 0.0
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
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.8)
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.colors = colors
        gradientLayer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        gradientLayer.shadowOpacity = 0.3
        gradientLayer.shadowRadius = 5
        gradientLayer.shadowColor = UIColor.black.cgColor
        return gradientLayer
    }()
    
    private lazy var highlightLayer: CALayer = {
        let highlightLayer = CALayer()
        highlightLayer.backgroundColor = UIColor.black.cgColor
        highlightLayer.opacity = 0.3
        highlightLayer.isHidden = !isHighlighted
        return highlightLayer
    }()
    
    private let cornerLayer = CAShapeLayer()
    private let notEnabledColors = [UIColor.lightGray.cgColor, UIColor.lightGray.cgColor]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.mask = cornerLayer
        self.layer.addSublayer(gradientLayer)
        self.layer.addSublayer(highlightLayer)
    }
    
    open override var isHighlighted: Bool {
        didSet {
            if oldValue == isHighlighted {
                return
            }
            highlightLayer.isHidden = !isHighlighted
        }
    }
    
    open override var isEnabled: Bool {
        didSet {
            if oldValue == isEnabled {
                return
            }
            gradientLayer.colors = isEnabled ? colors : notEnabledColors
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame  = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        highlightLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        
        let cornerRadii = CGSize(width: cornerRadiusWithShadow, height: cornerRadiusWithShadow)
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: roundingCorners, cornerRadii: cornerRadii)
        cornerLayer.path = maskPath.cgPath
        cornerLayer.frame = self.bounds
    }
}
