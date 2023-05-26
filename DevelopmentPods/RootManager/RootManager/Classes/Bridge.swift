//
//  RootManager.swift
//  RootManager
//
//  Created by Condy on 2020/12/29.
//

import UIKit
import AppMain
import FeatBox

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
    
    /// 解决双窗口`Alert`并没有悼念模式问题
    /// - Parameter alert: 其他窗口`Alert`
    public func alertDisplayMorun(alert: UIView?) {
        appDelegates.bolting(type: MournAppDelegate.self)?.alertDisplayMorun(alert: alert)
    }
}
