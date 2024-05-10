//
//  WMTabBarItemContentView.swift
//  AppMain
//
//  Created by Condy on 2024/5/10.
//

import Foundation
import ESTabBarController_swift

/// 上图下文带动画
final class WMTabBarItemContentView: ESTabBarItemContentView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.renderingMode = .alwaysOriginal
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateLayout() {
        let w = self.bounds.size.width
        let h = CGFloat(48.0)
        imageView.isHidden = (imageView.image == nil)
        titleLabel.isHidden = (titleLabel.text == nil)
        
        if !imageView.isHidden && !titleLabel.isHidden {
            titleLabel.sizeToFit()
            imageView.sizeToFit()
            titleLabel.frame = CGRect.init(x: (w - titleLabel.bounds.size.width) / 2.0,
                                           y: h - titleLabel.bounds.size.height - 4.0,
                                           width: titleLabel.bounds.size.width,
                                           height: titleLabel.bounds.size.height)
            imageView.frame = CGRect.init(x: (w - imageView.bounds.size.width) / 2.0,
                                          y: (h - imageView.bounds.size.height) / 2.0 - 8.0,
                                          width: imageView.bounds.size.width,
                                          height: imageView.bounds.size.height)
        } else if !imageView.isHidden {
            imageView.sizeToFit()
            imageView.center = CGPoint.init(x: w / 2.0, y: h / 2.0)
        } else if !titleLabel.isHidden {
            titleLabel.sizeToFit()
            titleLabel.center = CGPoint.init(x: w / 2.0, y: h / 2.0)
        }
        
        if let _ = badgeView.superview {
            let size = badgeView.sizeThatFits(self.frame.size)
            badgeView.frame = CGRect.init(origin: CGPoint.init(x: w / 2.0 + badgeOffset.horizontal, y: h / 2.0 + badgeOffset.vertical), size: size)
            badgeView.setNeedsLayout()
        }
    }
    
    public override func highlightAnimation(animated: Bool, completion: (() -> ())?) {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(0.4)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        imageView.layer.add(bounceAnimation, forKey: nil)
        completion?()
    }
}
