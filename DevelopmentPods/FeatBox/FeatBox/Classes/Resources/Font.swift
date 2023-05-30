//
//  Font.swift
//  FeatBox
//
//  Created by Condy on 2023/5/24.
//

import Foundation
import Extensions

public extension BoxWrapper where Base: UIFont {
    
    /// 重新设置字体尺寸
    public var fixedFont: UIFont {
        let fontSize = base.pointSize
        let fixedSize = fontSize + UserSettings.shared.fontSize
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
}
