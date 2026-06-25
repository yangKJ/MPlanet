//
//  UIView+Ext.swift
//  FeatBox
//
//  Created by Condy on 2022/4/25.
//

import Foundation

extension BoxWrapper where Base: UIView {
    
    public var viewController: UIViewController? {
        get {
            var view: UIView? = base
            while let wrappedView = view {
                if let nextResponder = wrappedView.next as? UIViewController {
                    return nextResponder
                }
                view = wrappedView.superview
            }
            return nil
        }
    }
    
    public var firstResponder: UIView? {
        if self.base.isFirstResponder {
            return self.base
        }
        var first: UIView?
        for subView in self.base.subviews {
            first = subView.fy.firstResponder
            if first != nil {
                break
            }
        }
        return first
    }
    
    public func closeKeyboard(force: Bool = false) {
        let view = firstResponder
        if view is UITextView || view is UITextField || view is UISearchBar {
            view?.resignFirstResponder()
        }
    }
    
    public var x: CGFloat {
        get {
            return base.frame.origin.x
        }
        set {
            base.frame.origin.x = newValue
        }
    }
    
    public var y: CGFloat {
        get {
            return base.frame.origin.y
        }
        set {
            base.frame.origin.y = newValue
        }
    }
    
    public var width: CGFloat {
        get {
            return base.frame.size.width
        }
        set {
            // 修复：直接修改 frame.size.width 在自动布局下会把 view 移到 (0,0)
            // 改为只改 size，保持 origin 不变。
            // 仍建议使用 Auto Layout/SnapKit 替代直接 frame 操作。
            var frame = base.frame
            frame.size.width = newValue
            base.frame = frame
        }
    }

    public var height: CGFloat {
        get {
            return base.frame.size.height
        }
        set {
            // 修复：同上，保留 origin
            var frame = base.frame
            frame.size.height = newValue
            base.frame = frame
        }
    }
    
    /// 设置多个圆角
    /// - Parameters:
    ///   - radii: 圆角幅度
    ///   - roundingCorners: 圆角方位，[.topLeft, .bottomRight]
    public func filletedCorner(radii: CGFloat, roundingCorners: UIRectCorner) {
        let cornerRadii = CGSize(width: radii, height: radii)
        let fieldPath = UIBezierPath(roundedRect: base.bounds, byRoundingCorners: roundingCorners, cornerRadii: cornerRadii)
        //base.layoutIfNeeded()
        let fieldLayer = CAShapeLayer()
        fieldLayer.frame = base.bounds
        fieldLayer.path = fieldPath.cgPath
        base.layer.mask = fieldLayer
    }
    
    /// 设置圆角半径
    /// - Note: 这里只设置圆角本身，不强制开启 shouldRasterize。
    ///   shouldRasterize 仅在视图是静态且需要离屏缓存时才有意义，
    ///   之前全局硬编码 true 会在动态内容（如 cell 复用、动画）下产生额外 GPU 开销和性能问题。
    public var cornerRadius: CGFloat {
        set {
            base.layer.cornerRadius = newValue
            base.layer.masksToBounds = newValue > 0
        }
        get {
            return base.layer.cornerRadius
        }
    }

    /// 设置圆角 + 离屏光栅化（仅适用于静态视图）
    /// - Note: 滚动 / 动画频繁的视图慎用，每次重绘都会重新生成 raster cache
    public var roundedCornerWithRasterize: CGFloat {
        set {
            base.layer.cornerRadius = newValue
            base.layer.masksToBounds = newValue > 0
            if newValue > 0 {
                base.layer.shouldRasterize = true
                base.layer.rasterizationScale = UIScreen.main.scale
            } else {
                base.layer.shouldRasterize = false
            }
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
    /// - Note: 拆分为 setCornerRadius / setShadow 两个独立方法，
    ///   不再隐式设置 shouldRasterize，避免 cell 复用时频繁触发 layer 变更。
    public var corOfShadow: CGFloat {
        set {
            setCornerRadius(newValue)
            setShadow(radius: newValue)
        }
        get {
            return cornerRadius
        }
    }

    /// 单独设置圆角（不影响阴影 / rasterize）
    public func setCornerRadius(_ value: CGFloat) {
        base.layer.cornerRadius = value
        base.layer.masksToBounds = value > 0
    }

    /// 单独设置阴影
    /// - Note: 默认关闭 shouldRasterize。Cell 复用或动画场景下 shouldRasterize 会带来额外 GPU 开销。
    public func setShadow(radius: CGFloat) {
        if radius == 0 {
            base.layer.shadowOpacity = 0
            base.layer.masksToBounds = true
        } else {
            if base.backgroundColor == nil {
                base.backgroundColor = UIColor.white
            }
            base.layer.shadowColor = UIColor.black.cgColor
            base.layer.shadowOffset = CGSize(width: 0, height: 4.0)
            base.layer.shadowOpacity = 0.05
            base.layer.shadowRadius = radius
            base.layer.masksToBounds = false
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
