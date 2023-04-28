//
//  ZZShadowView.swift
//  FeatBox
//
//  Created by Condy on 2022/4/25.
//

import Foundation

/// 阴影视图控件
open class ZZShadowView: UIView {
    
    var shadowLayer: CAShapeLayer = CAShapeLayer()
    
    var cornerRadiusOfShadowAndSelf: CGFloat = 0 {
        didSet {
            self.backgroundColor = UIColor.white
            self.layer.shadowOffset = CGSize(width: 0, height: 4.0)
            self.layer.shadowOpacity = 0.01
            self.layer.shadowRadius = 2
            self.layer.cornerRadius = cornerRadiusOfShadowAndSelf
            self.layer.shouldRasterize = true
            self.layer.rasterizationScale = UIScreen.main.scale
            self.layer.masksToBounds = false
        }
    }
}
