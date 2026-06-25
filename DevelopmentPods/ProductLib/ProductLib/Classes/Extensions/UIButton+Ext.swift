//
//  ExUIButton.swift
//  FeatBox
//
//  Created by Condy on 2020/11/23.
//

import UIKit

fileprivate var touchAreaInsetsKey: UInt8 = 0

extension BoxWrapper where Base: UIButton {
    
    /// Typically, the touch area of an UIButton object is described by its frame or all point inside its superview's frame.
    /// Now you can increase/decrease the touch area by modify this property.
    /// By default is UIEdgeInsetsZero,which means no increase/decrease touch area.
    public var touchAreaInsets: UIEdgeInsets {
        set {
            let insets = NSValue(uiEdgeInsets: newValue)
            // 修复：objc_setAssociatedObject 的第一个参数是 host object，应该传 base (UIButton)，
            // 传 self (BoxWrapper) 时 associated object 实际存到 BoxWrapper 上，
            // 但 getter 又从 self 上读（因为 BoxWrapper 是值类型，被桥接封装），造成读写错位。
            objc_setAssociatedObject(base, &touchAreaInsetsKey, insets, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(base, &touchAreaInsetsKey) as? NSValue)?.uiEdgeInsetsValue ?? .zero
        }
    }
    
    /// 自由调整图标按钮中的图标和文字位置
    /// Free to set the icon and text position in the icon button.
    /// - Parameters:
    ///   - image: 图标
    ///   - title: 文字
    ///   - titlePosition: 文字位置
    ///   - spacing: 图文间距
    ///   - state: UI控制状态
    public func set(image: UIImage?, title: String, titlePosition: UIView.ContentMode, additional spacing: CGFloat, state: UIControl.State) {
        guard let titleFont = base.titleLabel?.font else {
            return
        }
        base.imageView?.contentMode = .center
        base.setImage(image, for: state)
        
        let titleSize = title.size(withAttributes: [NSAttributedString.Key.font: titleFont])
        let imageSize = base.imageRect(forContentRect: base.frame)
        var titleInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        var imageInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        switch (titlePosition) {
        case .top:
            titleInsets.top = -(imageSize.height + titleSize.height + spacing)
            titleInsets.left = -imageSize.width
            imageInsets.right = -titleSize.width
        case .bottom:
            titleInsets.top = imageSize.height + titleSize.height + spacing
            titleInsets.left = -imageSize.width
            imageInsets.right = -titleSize.width
        case .left:
            titleInsets.left = -(imageSize.width * 2)
            imageInsets.right = -(titleSize.width * 2 + spacing)
        case .right:
            titleInsets.right = -spacing
        default:
            break
        }
        
        base.titleEdgeInsets = titleInsets
        base.imageEdgeInsets = imageInsets
        base.titleLabel?.contentMode = .center
        base.setTitle(title, for: state)
    }
}
