//
//  WeakProxy.swift
//  ProductLib
//
//  Created by Condy on 2023/11/27.
//

import Foundation

public class WeakProxy: NSObject {
    private weak var target: NSObjectProtocol?

    public init(target: NSObjectProtocol) {
        self.target = target
        super.init()
    }

    public class func proxy(withTarget target: NSObjectProtocol) -> WeakProxy {
        return WeakProxy(target: target)
    }

    public override func forwardingTarget(for aSelector: Selector!) -> Any? {
        // 修复：当 target 已释放时直接返回 nil，让 runtime 走 doesNotRecognizeSelector
        // 路径而不是 crash。NSMethodSignature 在 Swift 中不可用，所以靠 forwardingTarget
        // 单点转发：target 还在就把消息转给 target，target 没了就 nil 触发 doesNotRecognizeSelector。
        return target
    }

    public override func responds(to aSelector: Selector!) -> Bool {
        return target?.responds(to: aSelector) ?? false
    }
}
