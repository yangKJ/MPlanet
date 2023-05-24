//
//  Font+Fixed.swift
//  FeatBox
//
//  Created by Condy on 2023/5/24.
//

import Foundation
import Contacts

extension BoxWrapper where Base: UIFont {
    
    public var fixedFont: UIFont {
        let fontSize = base.pointSize
        let fixedSize = min(20, fontSize + UserDefaults.shared.fontSizeType.deltaFontSize)
        return base.withSize(fixedSize)
    }
    
    public static func systemFont(ofSize fontSize: CGFloat) -> UIFont {
        UIFont.systemFont(ofSize: fontSize).ai.fixedFont
    }
    
    public static func boldSystemFont(ofSize fontSize: CGFloat) -> UIFont {
        UIFont.boldSystemFont(ofSize: fontSize).ai.fixedFont
    }
    
    public static func italicSystemFont(ofSize fontSize: CGFloat) -> UIFont {
        UIFont.italicSystemFont(ofSize: fontSize).ai.fixedFont
    }
}
