//
//  NSObject+Ext.swift
//  FeatBox
//
//  Created by Condy on 2023/4/28.
//

import Foundation

/// Equivalent to @synchronized(key) { } in Objective-C.
/// - 注意:defer 必须紧跟 `objc_sync_enter` 之后立即声明,
///   这样即使 `execute` 抛出 Swift 错误/异常,defer 也能保证 `objc_sync_exit` 被调用。
///   Apple 文档明确说明 `objc_sync_enter` 异常时行为未定义,
///   但 defer 是 Swift 唯一的"必须调用 cleanup"的语义保障。
public func synchronized<_Tp>(_ key: Any, execute: () -> _Tp) -> _Tp {
    objc_sync_enter(key)
    defer { objc_sync_exit(key) }
    let result = execute()
    return result
}

fileprivate extension NSObject {
    /// NSObject对象获取类型
    fileprivate var runtimeType: NSObject.Type {
        type(of: self)
    }
}

extension BoxWrapper where Base: NSObject {
    
    /// 对象获取类的字符串名称
    public var className: String {
        base.runtimeType.fy.class_name
    }
    
    /// 类获取类的字符串名称
    public static var class_name: String {
        String(describing: self)
    }
}
