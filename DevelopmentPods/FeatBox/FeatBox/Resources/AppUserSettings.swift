//
//  AppUserSettings.swift
//  FeatBox
//
//  Created by Condy on 2023/5/24.
//

import Foundation
import ProductLib

/// 存储在`UserDefaults`当中的数据
public struct AppUserSettings {
    
    @UserDefault_("set_user_font_size_type", defaultValue: FontSizeType.standard.deltaFontSize)
    private static var fontSize: CGFloat
    
    /// 登陆令牌，退出登陆不会清空该数据
    @UserDefault_("__hasUserLoggedToken__", defaultValue: nil)
    public static var token: String?
    
    /// 是否第一次启动
    @UserDefault_("__hasLaunched__", defaultValue: true)
    public static var isFirstLaunch: Bool
    
    /// 悼念模式
    @UserDefault_("__hasMourn__", defaultValue: MournType.none.rawValue)
    private static var mournTypeString: String
    
    /// 悼念模式开始时间
    @UserDefault_("__hasMournStartTime__", defaultValue: 0.0)
    public static var mournStartTime: TimeInterval
    
    /// 悼念模式结束时间
    @UserDefault_("__hasMournEndTime__", defaultValue: 0.0)
    public static var mournEndTime: TimeInterval
}

extension AppUserSettings {
    /// 字体尺寸类型
    public static var fontSizeType: FontSizeType {
        get {
            return FontSizeType(rawValue: Int(fontSize)) ?? .standard
        }
        set {
            self.fontSize = newValue.deltaFontSize
        }
    }
    /// 悼念模式
    public static var mournType: MournType {
        MournType(rawValue: mournTypeString) ?? .none
    }
}
