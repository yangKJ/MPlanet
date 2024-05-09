//
//  WMBounceAnimation.swift
//  AppMain
//
//  Created by Condy on 2021/12/29.
//

import Foundation
import RAMAnimatedTabBarController

class WMBounceAnimation: RAMItemAnimation {
    
    var iconImage: UIImage?
    var iconSelectedImage: UIImage?
    
    var iconSize: CGSize? {
        didSet {
            guard let iconSize = iconSize, iconSize != .zero else {
                return
            }
            
        }
    }
    
    /// 开始播放
    /// - Parameters:
    ///   - icon: 图片
    ///   - textLabel: 文本
    open override func playAnimation(_ icon: UIImageView, textLabel: UILabel) {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(duration)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        icon.layer.add(bounceAnimation, forKey: nil)
        
        textLabel.textColor = textSelectedColor
        icon.image = iconSelectedImage!
    }
    
    /// 选中
    /// - Parameters:
    ///   - icon: 图标
    ///   - textLabel: 文本
    open override func selectedState(_ icon: UIImageView, textLabel: UILabel) {
        textLabel.textColor = textSelectedColor
        icon.image = iconSelectedImage!
    }
    
    /**
     Start animation, method call when UITabBarItem is unselected
     
     - parameter icon: animating UITabBarItem icon
     - parameter textLabel: animating UITabBarItem textLabel
     - parameter defaultTextColor: default UITabBarItem text color
     - parameter defaultIconColor: default UITabBarItem icon color
     */
    open override func deselectAnimation(_ icon: UIImageView,
                                         textLabel: UILabel,
                                         defaultTextColor: UIColor,
                                         defaultIconColor: UIColor) {
        textLabel.textColor = defaultTextColor
        icon.image = iconImage!
    }
}
