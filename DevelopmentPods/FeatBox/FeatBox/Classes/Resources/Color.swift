//
//  Color.swift
//  FeatBox
//
//  Created by Condy on 2021/1/25.
//

import Foundation
import Extensions

/// 添加 `ai` 前缀，颜色必须走这块方便后续做主题
public extension BoxWrapper where Base: UIColor {
    
    /// 随机颜色
    static var random: UIColor {
        return UIColor.random
    }
    
    /// 主色调
    static var mainColor: UIColor {
        return UIColor(hex: "#82C87C")
    }
    
    /// 背景色
    static var background: UIColor {
        return UIColor.white
    }
    
    /// 标题颜色
    static var title: UIColor {
        return UIColor.black
    }
    
    /// 副标题颜色
    static var detailTitle: UIColor {
        return UIColor(hex: "#999999")
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
    
    static var clear: UIColor {
        return UIColor.clear
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
    
    static var gray_F3F3F3: UIColor {
        UIColor(hex: "#F3F3F3")
    }
    
    static var gray_F7F7F7: UIColor {
        UIColor(hex: "#F7F7F7")
    }
    
    static var gray_CCCCCC: UIColor {
        UIColor(hex: "#CCCCCC")
    }
    
    static var gray_999999: UIColor {
        UIColor(hex: "#999999")
    }
    
    /// 青蓝
    static var lightBlue: UIColor {
        UIColor(hex: "#29B5FE")
    }
    /// 亮橙
    static var lightOrange: UIColor {
        UIColor(hex: "#FFBB50")
    }
    /// 浅绿
    static var lightGreen: UIColor {
        UIColor(hex: "#1AC756")
    }
    /// 浅红
    static var lightRed: UIColor {
        UIColor(hex: "#FA6D5B")
    }
}
