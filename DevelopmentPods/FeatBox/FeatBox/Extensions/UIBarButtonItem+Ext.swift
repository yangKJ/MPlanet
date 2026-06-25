//
//  UIBarButtonItem+Ext.swift
//  FeatBox
//
//  Created by Condy on 2025/5/20.
//

import Foundation
import ProductLib

extension UIBarButtonItem {
    
    public convenience init(title: String?,
                            color: UIColor = UIColor.fy.navBarTitle,
                            font: UIFont = UIFont.fy.system_15,
                            width: CGFloat = 50,
                            target: Any?,
                            action: Selector?,
                            position: UIControl.ContentHorizontalAlignment = .left) {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = font.fy.fixedFont
        button.setTitle(title, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.setTitleColor(color.withAlphaComponent(0.4), for: .disabled)
        if let action = action {
            button.addTarget(target, action: action, for: .touchUpInside)
        }
        button.sizeToFit()
        button.width = max(width, button.width)
        button.height = max(44, button.height)
        button.contentHorizontalAlignment = position
        self.init(customView: button)
    }
    
    public convenience init(image: UIImage?,
                            highlightedImage: UIImage? = nil,
                            width: CGFloat = 50,
                            target: Any?,
                            action: Selector,
                            position: UIControl.ContentHorizontalAlignment = .left) {
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.setImage(highlightedImage, for: .highlighted)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.sizeToFit()
        button.width = max(width, button.width)
        button.height = max(44, button.height)
        button.contentHorizontalAlignment = position == .left ? .left : .right
        self.init(customView: button)
    }
}

extension BoxWrapper where Base == UIBarButtonItem {
    
    public static func popOutButton(target: Any?, action: Selector, width: CGFloat = 50) -> UIBarButtonItem {
        return UIBarButtonItem(image: Res.black_back_arrow, width: width, target: target, action: action)
    }
    
    public static func dismissButton(target: Any?, action: Selector, width: CGFloat = 50) -> UIBarButtonItem {
        return UIBarButtonItem(image: Res.black_close, width: width, target: target, action: action)
    }
}
