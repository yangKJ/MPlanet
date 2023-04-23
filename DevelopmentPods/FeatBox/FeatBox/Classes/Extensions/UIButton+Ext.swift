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
            objc_setAssociatedObject(self, &touchAreaInsetsKey, insets, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self, &touchAreaInsetsKey) as? NSValue)?.uiEdgeInsetsValue ?? .zero
        }
    }
}
