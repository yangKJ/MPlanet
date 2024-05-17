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
        return target
    }
    
    public override func responds(to aSelector: Selector!) -> Bool {
        return target?.responds(to: aSelector) ?? false
    }
}
