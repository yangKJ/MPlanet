//
//  Swizzle.swift
//  Extensions
//
//  Created by Condy on 2023/5/20.
//

import Foundation
import ObjectiveC

public struct Swizzle<T: NSObject> {
    
    public typealias SelectorMethod = (original: Selector, swizzled: Selector)
    
    /// 方法交换
    /// - Parameters:
    ///   - type: 交换对象
    ///   - methods: 交换的方法列表
    public static func swizzle(_ type: T.Type, methods: [SelectorMethod]) {
        methods.forEach { original, swizzled in
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
        }
    }
}
