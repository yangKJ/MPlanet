//
//  Placeholder.swift
//  FeatBox
//
//  Created by Condy on 2023/3/10.
//

import Foundation
import Harbeth
import Cabinets

/// 各种占位图
public struct Placeholder {
    
    /// 主色调纯色占位图
    public static var mainColor: C7Image {
        UIColor.kj.mainColor.mt.colorImage(with: CGSize(width: 100, height: 100)) ?? C7Image()
    }
    
    /// 灰色占位图
    public static var gray: C7Image {
        UIColor.kj.gray.mt.colorImage(with: CGSize(width: 100, height: 100)) ?? C7Image()
    }
    
    public static var itemShadowImage: C7Image? {
        UIColor.kj.itemShadowImageColor.mt.colorImage()
    }
}
