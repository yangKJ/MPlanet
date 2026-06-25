//
//  Color.swift
//  FeatBox
//
//  Created by Condy on 2021/1/25.
//

import Foundation
import ProductLib

/// 添加 `fy` 前缀，颜色必须走这块方便后续做主题
public extension BoxWrapper where Base: UIColor {
    
    /// 随机颜色
    static var random: UIColor {
        let red = CGFloat(arc4random() % 256) / 255.0
        let green = CGFloat(arc4random() % 256) / 255.0
        let blue = CGFloat(arc4random() % 256) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    /// 主色调
    public static var mainColor: UIColor {
        return UIColor(hex: "#82C87C")
    }
    
    /// 标题颜色
    static var title: UIColor {
        return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    /// 背景色
    static var background: UIColor {
        return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    /// 全局背景灰色
    static var backgroundGray: UIColor {
        return UIColor(hex: "#F7F7F7")
    }
    
    static var navBarTitle: UIColor {
        return UIColor(hex: "#333333")
    }
    
    static var navBarItem: UIColor {
        return UIColor(hex: "#333333")
    }
    
    static var placeholder: UIColor {
        UIColor(hex: "#CCCCCC")
    }
    
    /// 副标题颜色
    static var detailTitle: UIColor {
        return UIColor(hex: "#999999")
    }
    
    /// 线条颜色
    static var line: UIColor {
        return UIColor(hex: "#EFEFEF")
    }
    
    static var darkLine: UIColor {
        return UIColor(hex: "#CDCDCD")
    }
    
    static var linkBlue: UIColor {
        return UIColor(hex: "#578ff9")
    }
    
    static var itemShadowImageColor: UIColor {
        return UIColor(white: 230/255.0, alpha: 1.0)
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
    
    static var black_333333: UIColor {
        UIColor(hex: "#333333")
    }
    
    static var black_666666: UIColor {
        UIColor(hex: "#666666")
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

    /// 美化：次级灰，比 gray_999999 更柔的副文本色，用于时间戳/低优先级文案
    static var gray_B0B0B0: UIColor {
        UIColor(hex: "#B0B0B0")
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
    
    static var blue_1687FF: UIColor {
        UIColor(hex: "#1687FF")
    }
}
