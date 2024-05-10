//
//  UserSettings.swift
//  FeatBox
//
//  Created by Condy on 2023/5/24.
//

import Foundation
import ProductLib

/// 存储在`UserDefaults`当中的数据
public struct UserSettings {
    
    @UserDefault_("root_manager_open_mourning_mode", defaultValue: false)
    public static var mourning: Bool
    
    public static var fontSizeType: FontSizeType {
        get {
            return FontSizeType(rawValue: Int(fontSize)) ?? .standard
        }
        set {
            self.fontSize = newValue.deltaFontSize
        }
    }
    
    @UserDefault_("set_user_font_size_type", defaultValue: FontSizeType.standard.deltaFontSize)
    private static var fontSize: CGFloat
    
    @UserDefault_("mine_user_logged_token", defaultValue: nil)
    public static var token: String?
}
