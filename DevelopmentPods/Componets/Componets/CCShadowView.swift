//
//  CCShadowView.swift
//  FeatBox
//
//  Created by Condy on 2022/4/25.
//

import Foundation
import UIKit

/// 阴影视图控件
open class CCShadowView: UIView {

    var shadowLayer: CAShapeLayer = CAShapeLayer()

    var cornerRadiusOfShadowAndSelf: CGFloat = 0 {
        didSet {
            self.backgroundColor = UIColor.white
            self.layer.shadowOffset = CGSize(width: 0, height: 4.0)
            self.layer.shadowOpacity = 0.01
            self.layer.shadowRadius = 2
            self.layer.cornerRadius = cornerRadiusOfShadowAndSelf
            // 性能修复：仅在静态视图才开启 shouldRasterize；
            // 否则 cell 复用时频繁触发 layer 变更，带来 GPU raster cache 反复重建
            self.layer.masksToBounds = false
            // 性能修复：设置 shadowPath，避免离屏渲染每次都重新计算
            self.updateShadowPath()
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        // 性能修复：layoutSubviews 中更新 shadowPath，保证尺寸变更后路径有效
        updateShadowPath()
    }

    private func updateShadowPath() {
        // 使用 CGPath 一次性设置阴影路径，避免 iOS 自动计算
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: .allCorners,
                                cornerRadii: CGSize(width: cornerRadiusOfShadowAndSelf,
                                                    height: cornerRadiusOfShadowAndSelf))
        self.layer.shadowPath = path.cgPath
    }
}
