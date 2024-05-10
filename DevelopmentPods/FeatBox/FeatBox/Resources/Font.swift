//
//  Font.swift
//  FeatBox
//
//  Created by Condy on 2023/5/24.
//

import Foundation
import ProductLib

public enum FontSizeType: Int {
    case standard = 0
    case large
    case huge
    
    public var deltaFontSize: CGFloat {
        switch self {
        case .standard:
            return 0
        case .large:
            return 4
        case .huge:
            return 6
        }
    }
    
    public var description: String {
        switch self {
        case .standard:
            return "标准"
        case .large:
            return "较大"
        case .huge:
            return "特大"
        }
    }
}

public extension BoxWrapper where Base: UIFont {
    
    /// 重新设置字体尺寸
    public var fixedFont: UIFont {
        let fixedSize = base.pointSize + UserSettings.fontSizeType.deltaFontSize
        return base.withSize(fixedSize)
    }
    
    static var bold_18: UIFont {
        UIFont.boldSystemFont(ofSize: 18)
    }
    
    static var system_20: UIFont {
        UIFont.systemFont(ofSize: 20)
    }
    
    static var system_18: UIFont {
        UIFont.systemFont(ofSize: 18)
    }
    
    static var system_16: UIFont {
        UIFont.systemFont(ofSize: 16)
    }
    
    static var system_14: UIFont {
        UIFont.systemFont(ofSize: 14)
    }
    
    static var system_10: UIFont {
        UIFont.systemFont(ofSize: 10)
    }
}
