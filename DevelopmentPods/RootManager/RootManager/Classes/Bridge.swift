//
//  Bridge.swift
//  RootManager
//
//  Created by Condy on 2023/3/13.
//

import Foundation

/// 中转站，供外界使用
public struct Bridge {
    
    public lazy var appDelegate: AppDelegateType = {
        let composite = CompositeAppDelegate.init(appDelegates: appDelegates)
        return composite
    }()
    
    weak var window: UIWindow?
    let appDelegates: [AppDelegateType]
    
    public init(_ window: UIWindow?) {
        self.window = window
        self.appDelegates = [
            RootViewControllerAppDelegate(window: window),
            MournAppDelegate(window: window),
        ]
    }
}

extension Bridge {
    
    private func delegate<T: AppDelegateType>(type: T.Type) -> T? {
        guard let delegate = appDelegates.first(where: { $0 is T }) as? T else {
            return nil
        }
        return delegate
    }
    
    /// 解决双窗口`Alert`并没有悼念模式问题
    /// - Parameter alert: 其他窗口`Alert`
    public func alertDisplayMorun(alert: UIView?) {
        let delegate = delegate(type: MournAppDelegate.self)
        delegate?.alertDisplayMorun(alert: alert)
    }
}
