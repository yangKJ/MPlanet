//
//  MineTarget.swift
//  WMMine
//
//  Created by Condy on 2020/12/28.
//

import UIKit

@objc public final class MineTarget: NSObject {

    @objc public func getMineViewControllerType() -> UIViewController.Type {
        return MineViewController.self
    }

    /// WMTabBarItem.makeViewController() 调用此方法
    @objc public func Action_viewController(_ params: [String: Any]?) -> UIViewController {
        let userId = params?["userId"] as? String
        let vc = MineViewController()
        vc.userId = userId
        return vc
    }

    /// 备注提示，这里必须加上`@objc`
    /// 否则会出现找不到该方法从而导致控制器为`nil`问题
    @objc public func setupMineViewController(_ params: NSDictionary) -> UIViewController? {
        let userId = params["userId"] as? String
        let vc = MineViewController.init()
        vc.userId = userId
        return vc
    }
}
