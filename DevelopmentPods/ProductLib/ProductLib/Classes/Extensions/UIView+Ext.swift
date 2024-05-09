//
//  UIView+Ext.swift
//  FeatBox
//
//  Created by Condy on 2022/4/25.
//

import Foundation

extension BoxWrapper where Base: UIView {
    
    /// 设置多个圆角
    ///
    /// - Parameters:
    ///   - radii: 圆角幅度
    ///   - roundingCorners: 圆角方位，[.topLeft, .bottomRight]
    public func filletedCorner(radii: CGFloat, roundingCorners: UIRectCorner)  {
        let fieldPath = UIBezierPath(roundedRect: base.bounds,
                                     byRoundingCorners: roundingCorners,
                                     cornerRadii: CGSize(width: radii, height: radii))
        base.layoutIfNeeded()
        let fieldLayer = CAShapeLayer()
        fieldLayer.frame = base.bounds
        fieldLayer.path = fieldPath.cgPath
        base.layer.mask = fieldLayer
    }
    
    /// 设置圆角半径
    public var cornerRadius: CGFloat {
        set {
            base.layer.cornerRadius = newValue
            base.layer.masksToBounds = newValue > 0
            base.layer.shouldRasterize = true
            base.layer.rasterizationScale = UIScreen.main.scale
        }
        get {
            return base.layer.cornerRadius
        }
    }
    
    /// 设置边框宽度
    public var borderPxwidth: CGFloat {
        set {
            base.layer.borderWidth = newValue * 1.0 / UIScreen.main.scale
        }
        get {
            return base.layer.borderWidth / 1.0 / UIScreen.main.scale
        }
    }
    
    /// 设置边框颜色和宽度
    public func borderPxwidthAndColor(_ color: UIColor, px: CGFloat) {
        base.layer.borderColor = color.cgColor
        base.layer.borderWidth = px * 1.0 / UIScreen.main.scale
    }
    
    /// 设置阴影半径
    public var corOfShadow: CGFloat {
        set {
            cornerRadius = newValue
            if newValue == 0 {
                base.layer.shadowOpacity = 0
                base.layer.masksToBounds = true
            } else {
                if base.backgroundColor == nil {
                    base.backgroundColor = UIColor.white
                }
                base.layer.shadowColor = UIColor.black.cgColor
                base.layer.shadowOffset = CGSize(width: 0, height: 4.0)
                base.layer.shadowOpacity = 0.05
                base.layer.shadowRadius = newValue
                base.layer.masksToBounds = false
            }
        }
        get {
            return cornerRadius
        }
    }
    
    /// 旋转90度
    public func rotation90() {
        base.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    }
    
    /// 旋转180度
    public func rotation180() {
        base.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    }
    
    /// 旋转270度
    public func rotation270() {
        base.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
    }
}
