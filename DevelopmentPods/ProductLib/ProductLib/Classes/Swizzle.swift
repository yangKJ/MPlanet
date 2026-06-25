//
//  Swizzle.swift
//  Extensions
//
//  Created by Condy on 2023/5/20.
//

import Foundation
import ObjectiveC

/// 实现方法交换的类必须是继承自`NSObject`
public struct Swizzle<T: NSObject> {

    public typealias SelectorMethod = (original: Selector, swizzled: Selector)

    /// 检查某个 selector 是否已被本结构体交换过
    private static func hasSwizzled(_ type: T.Type, selector: Selector) -> Bool {
        SwizzleStorage.lock.lock()
        defer { SwizzleStorage.lock.unlock() }
        let key = ObjectIdentifier(type)
        return SwizzleStorage.tokens[key]?.contains(selector) ?? false
    }

    /// 标记某个 selector 已被本结构体交换过
    private static func markSwizzled(_ type: T.Type, selector: Selector) {
        SwizzleStorage.lock.lock()
        defer { SwizzleStorage.lock.unlock() }
        let key = ObjectIdentifier(type)
        var list = SwizzleStorage.tokens[key] ?? []
        if !list.contains(selector) {
            list.append(selector)
        }
        SwizzleStorage.tokens[key] = list
    }

    /// 实例方法交换
    /// - Parameters:
    ///   - type: 交换对象
    ///   - methods: 交换的方法列表
    public static func swapInstanceMethods(_ type: T.Type = T.self, methods: [SelectorMethod]) {
        methods.forEach { original, swizzled in
            // 修复：dispatch_once 风格的幂等保护
            // 防止多次调用导致 original 和 swizzled 实现再次互换
            if hasSwizzled(type, selector: original) {
                return
            }
            guard let originalMethod = class_getInstanceMethod(type, original),
                  let swizzledMethod = class_getInstanceMethod(type, swizzled) else {
                return
            }
            let didAddMethod = class_addMethod(type, original, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            if didAddMethod {
                class_replaceMethod(type, swizzled, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
            markSwizzled(type, selector: original)
        }
    }

    public static func swapClassMethods(_ type: T.Type = T.self, methods: [SelectorMethod]) {
        methods.forEach { original, swizzled in
            if hasSwizzled(type, selector: original) {
                return
            }
            guard let originalMethod = class_getClassMethod(type, original),
                  let swizzledMethod = class_getClassMethod(type, swizzled) else {
                return
            }
            let didAddMethod = class_addMethod(type, original, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            if didAddMethod {
                class_replaceMethod(type, swizzled, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
            markSwizzled(type, selector: original)
        }
    }
}

// 修复：Swift 泛型 struct 不支持 static stored properties
// 把 swizzled tokens / lock 提取到非泛型 enum 持有，规避此限制
private enum SwizzleStorage {
    nonisolated(unsafe) static var tokens: [ObjectIdentifier: [Selector]] = [:]
    // NSLock 本身是 Sendable，不需要 nonisolated(unsafe)
    static let lock = NSLock()
}
