//
//  Placeholder.swift
//  FeatBox
//
//  Created by Condy on 2023/3/10.
//

import Foundation
import ProductLib

/// 各种占位图
public struct Placeholder {
    
    /// 主色调纯色占位图
    public static let mainColor = Methods.colorImage(with: UIColor.fy.mainColor, width: 100, height: 100)
    
    /// 灰色占位图
    public static let gray = Methods.colorImage(with: UIColor.fy.gray, width: 100, height: 100)
    
    /// 网图占位图
    public static let webImage = Methods.colorImage(with: UIColor.fy.gray, width: 100, height: 100)
    
    public static let itemShadowImage = Methods.colorImage(with: UIColor.fy.itemShadowImageColor, width: 1, height: 1)
}
