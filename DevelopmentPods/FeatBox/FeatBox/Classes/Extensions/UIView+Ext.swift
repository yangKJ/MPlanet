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
    ///   - cornerRadii: 圆角幅度
    ///   - roundingCorners: UIRectCorner(rawValue: (UIRectCorner.topRight.rawValue) | (UIRectCorner.bottomRight.rawValue))
    public func filletedCorner(_ cornerRadii: CGSize, roundingCorners: UIRectCorner)  {
        let fieldPath = UIBezierPath(roundedRect: base.bounds, byRoundingCorners: roundingCorners, cornerRadii:cornerRadii)
        let fieldLayer = CAShapeLayer()
        fieldLayer.frame = base.bounds
        fieldLayer.path = fieldPath.cgPath
        base.layer.mask = fieldLayer
    }
    
    /// 设置圆角半径
    var cornerRadius: CGFloat {
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
    var borderPxwidth: CGFloat {
        set {
            base.layer.borderWidth = newValue * 1.0 / UIScreen.main.scale
        }
        get {
            return base.layer.borderWidth / 1.0 / UIScreen.main.scale
        }
    }
    
    /// 设置阴影半径
    var corOfShadow: CGFloat {
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
}
