//
//  UserSettings.swift
//  FeatBox
//
//  Created by Condy on 2023/5/24.
//

import Foundation
import Extensions

/// 存储在`UserDefaults`当中的数据
public struct UserSettings {
    
    public static var shared = UserSettings()
    
    @UserDefault_("root_manager_open_mourning_mode", defaultValue: false)
    public var mourning: Bool
    
    public var fontSizeType: FontSizeType {
        get { FontSizeType(rawValue: Int(fontSize)) ?? .standard }
        set { self.fontSize = newValue.deltaFontSize }
    }
    
    @UserDefault_("set_user_font_size_type", defaultValue: FontSizeType.standard.deltaFontSize)
    private var fontSize: CGFloat
}
