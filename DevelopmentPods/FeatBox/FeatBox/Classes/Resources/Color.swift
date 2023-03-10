//
//  Color.swift
//  FeatBox
//
//  Created by Condy on 2021/1/25.
//

import Foundation

/// 添加 `cdy` 前缀
public extension BoxWrapper where Base: UIColor {
    
    /// 主色调
    static var mainColor: UIColor {
        return UIColor.init(red: 23/255.0, green: 23/255.0, blue: 25/255.0, alpha: 1.0)
    }
    
    /// 背景色
    static var background: UIColor {
        return .white
    }
    
    static var itemShadowImageColor: UIColor {
        return UIColor(red: 230.0 / 255.0, green: 230.0 / 255.0,  blue: 230.0 / 255.0, alpha: 1.0)
    }
    
    static var itemTitle: UIColor {
        return UIColor.white
    }
    
    static var itemSubTitle: UIColor {
        return UIColor.init(red: 169/255.0, green: 169/255.0, blue: 170/255.0, alpha: 1.0)
    }
    
    static var black: UIColor {
        return UIColor.black
    }
    
    static var white: UIColor {
        return UIColor.white
    }
    
    static var green: UIColor {
        return UIColor.green
    }
    
    static var red: UIColor {
        return UIColor.red
    }
    
    static var blue: UIColor {
        return UIColor.blue
    }
    
    static var gray: UIColor {
        return UIColor.gray
    }
    
    static var yellow: UIColor {
        return UIColor.yellow
    }
}
