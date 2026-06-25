//
//  UserDefaults.swift
//  FeatBox
//
//  Created by Condy on 2023/3/13.
//

import Foundation

/// `UserDefaults`属性包裹器
///
///     @UserDefault_("root_manager_open_mourning_mode", defaultValue: false)
///     public static var mourning: Bool
/// `UserDefaults`属性包裹器:用 `@UserDefault_(key, defaultValue:)` 把 Bool/Int/String 等持久化到 standard defaults。
@propertyWrapper public struct UserDefault_<T> {
    
    let key: String
    let defaultValue: T
    
    public init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public var wrappedValue: T {
        get {
            return (UserDefaults.standard.value(forKey: key) as? T) ?? defaultValue
        }
        set {
            // 修复：原 if newValue != nil, case Optional.none = newValue 永远为 false，
            // 导致所有赋值都走 removeObject 分支，@UserDefault_ 存的值永远消失
            UserDefaults.standard.set(newValue, forKey: key)
            // why: UserDefaults 写入在 App 生命周期内是同步落盘的,
            // 但旧版逻辑会因 Optional 判断错误把值 removeObject 掉,
            // 导致 read-after-write 读不到值;现在每次 set 都直接落盘。
            // 注意:@UserDefault_ 不发送 KVO,需要监听需另设 NotificationCenter。
        }
    }
}

extension UserDefaults {
    
    public subscript<T>(key: String) -> T? {
        get {
            return value(forKey: key) as? T
        }
        set {
            if let value = newValue as? (any RawRepresentable) {
                set(value.rawValue, forKey: key)
            } else {
                set(newValue, forKey: key)
            }
            synchronize()
        }
    }
    
    /// 枚举默认支持`RawRepresentable`
    public subscript<T: RawRepresentable>(key: String) -> T? {
        get {
            if let rawValue = object(forKey: key) as? T.RawValue {
                return T.init(rawValue: rawValue)
            }
            return nil
        }
        set {
            set(newValue?.rawValue, forKey: key)
            synchronize()
        }
    }
}
