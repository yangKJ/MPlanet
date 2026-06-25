//
//  AppUserSettings.swift
//  FeatBox
//
//  Created by Condy on 2023/5/24.
//

import Foundation
import ProductLib
import Security

/// 存储在`UserDefaults`当中的数据
public struct AppUserSettings {
    
    @UserDefault_("__hasDeltaFontSize__", defaultValue: FontSizeType.standard.deltaFontSize)
    private static var fontSize: CGFloat
    
    /// 登陆令牌，退出登陆不会清空该数据
    /// - Note: 安全修复：token 改用 Keychain 存储，不再写入 UserDefaults
    ///   （UserDefaults 是明文 plist，越狱或备份可读，存在泄漏风险）
    public static var token: String? {
        get {
            return (try? Keychain.shared.getString(key: "__hasUserLoggedToken__")) ?? nil
        }
        set {
            if let value = newValue {
                try? Keychain.shared.set(value: value, key: "__hasUserLoggedToken__")
            } else {
                try? Keychain.shared.remove(key: "__hasUserLoggedToken__")
            }
        }
    }
    
    /// 是否第一次启动
    @UserDefault_("__hasLaunched__", defaultValue: true)
    public static var isFirstLaunch: Bool
    
    /// 启动页当前版本号
    @UserDefault_("__hasLauncherVersion__", defaultValue: nil)
    public static var launcherVersion: String?
    
    /// 最后登陆时间节点
    @UserDefault_("__hasLastLoginTime__", defaultValue: nil)
    public static var lastLoginTime: TimeInterval?
    
    /// 悼念模式
    @UserDefault_("__hasMournType__", defaultValue: MournType.none.rawValue)
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
            var shouldNotificate = false
            if self.fontSize != newValue.deltaFontSize {
                shouldNotificate = true
            }
            self.fontSize = newValue.deltaFontSize
            if shouldNotificate {
                Notify.UI.fontChanged.post()
            }
        }
    }
    
    /// 悼念模式
    public static var mournType: MournType {
        MournType(rawValue: mournTypeString) ?? .none
    }
}
