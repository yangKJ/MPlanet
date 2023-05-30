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
@propertyWrapper public struct UserDefault_<T> {
    
    let key: String
    let defaultValue: T
    
    public init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public var wrappedValue: T {
        get {
            return UserDefaults.standard[self.key] ?? defaultValue
        }
        set {
            UserDefaults.standard[self.key] = newValue
        }
    }
}

extension UserDefault_ where T: RawRepresentable {
    
    public init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public var wrappedValue: T {
        get {
            return UserDefaults.standard[self.key] ?? defaultValue
        }
        set {
            UserDefaults.standard[self.key] = newValue
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
        }
    }
}
