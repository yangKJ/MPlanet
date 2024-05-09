//
//  Placeholder.swift
//  FeatBox
//
//  Created by Condy on 2023/3/10.
//

import Foundation
import Harbeth
import ProductLib

/// 各种占位图
public struct Placeholder {
    
    /// 主色调纯色占位图
    public static var mainColor: C7Image {
        colorImage(with: UIColor.fy.mainColor, width: 100, height: 100)
    }
    
    /// 灰色占位图
    public static var gray: C7Image {
        colorImage(with: UIColor.fy.gray, width: 100, height: 100)
    }
    
    public static var itemShadowImage: C7Image? {
        colorImage(with: UIColor.fy.itemShadowImageColor, width: 1, height: 1)
    }
    
    static func colorImage(with color: UIColor, width: CGFloat, height: CGFloat) -> C7Image {
        guard let texture = try? TextureLoader.emptyTexture(width: 100, height: 100) else {
            return C7Image()
        }
        let filter = C7SolidColor(color: color)
        let dest = HarbethIO(element: texture, filter: filter)
        guard let texture_ = try? dest.output() else {
            return C7Image()
        }
        return texture_.c7.toImage() ?? C7Image()
    }
}
