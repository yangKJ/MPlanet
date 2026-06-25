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

extension BoxWrapper where Base: UIFont {
    
    /// 重新设置字体尺寸
    public var fixedFont: UIFont {
        let fixedSize: CGFloat
        if base.pointSize >= 20 {
            fixedSize = base.pointSize
        } else {
            fixedSize = CGFloat.minimum(20, base.pointSize + AppUserSettings.fontSizeType.deltaFontSize)
        }
        return base.withSize(fixedSize)
    }
    
    public static func system(_ size: CGFloat, fixedFont: Bool = true) -> UIFont {
        if fixedFont {
            return UIFont.systemFont(ofSize: size).fy.fixedFont
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }
    
    public static func bold(_ size: CGFloat, fixedFont: Bool = true) -> UIFont {
        if fixedFont {
            return UIFont.boldSystemFont(ofSize: size).fy.fixedFont
        } else {
            return UIFont.boldSystemFont(ofSize: size)
        }
    }
}

public extension BoxWrapper where Base: UIFont {
    
    static var bold_16: UIFont { bold(16) }
    static var bold_18: UIFont { bold(18) }
    static var bold_20: UIFont { bold(20) }
    // 修复：WMWallet 用了 bold_14 但 token 表里没定义，补全
    static var bold_14: UIFont { bold(14) }
    
    static var system_20: UIFont { system(20) }
    static var system_18: UIFont { system(18) }
    static var system_16: UIFont { system(16) }
    static var system_15: UIFont { system(15) }
    static var system_14: UIFont { system(14) }
    static var system_13: UIFont { system(13) }
    static var system_12: UIFont { system(12) }
    static var system_10: UIFont { system(10) }
}
