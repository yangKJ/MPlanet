//
//  Mediator.swift
//  Mediator
//
//  Created by Condy on 2020/12/28.
//

import Foundation
import Rickenbacker

/// 特殊部分
extension Mediator {
    
    static let discoverTarget = "DiscoverTarget"
    static let walletTarget = "WalletTarget"
    static let mineTarget = "MineTarget"
    static let discoverModule = "WMDiscover"
    static let walletModule = "WMWallet"
    static let mineModule = "WMMine"
    
    public static func discoverViewControllerType() -> UIViewController.Type? {
        performTarget(discoverTarget, action: "getDiscoverViewControllerType", module: discoverModule) as? UIViewController.Type
    }
    public static func walletViewControllerType() -> UIViewController.Type? {
        performTarget(walletTarget, action: "getWalletViewControllerType", module: walletModule) as? UIViewController.Type
    }
    public static func mineViewControllerType() -> UIViewController.Type? {
        performTarget(mineTarget, action: "getMineViewControllerType", module: mineModule) as? UIViewController.Type
    }
    
    /// 跳转到标签页
    public static func gotoTabBarIndex(with gotoObject: String?) -> Bool {
        guard let gotoObject = gotoObject else {
            return false
        }
        let res = performTarget("AppMainTarget", action: "gotoTabBarIndex:", module: "AppMain", params: ["gotoObject": gotoObject])
        return (res as? Bool) ?? false
    }
}

/// 基础组件TabBar
extension Mediator {
    /// 发现组件
    public static func discoverTabBarViewController() -> UIViewController? {
        getCacheViewController(discoverTarget, action: "setupDiscoverViewController", module: discoverModule)
    }
    /// 钱包组件
    public static func walletTabBarViewController() -> UIViewController? {
        getCacheViewController(walletTarget, action: "setupWalletViewController", module: walletModule)
    }
    /// 我的组件
    public static func mineTabBarViewController(userId: String?) -> UIViewController? {
        getCacheViewController(mineTarget, action: "setupMineViewController:", module: mineModule, params: ["userId": userId])
    }
}

/// 组件之间访问
extension Mediator {
    /// Banner详情
    public static func bannerDetailViewController(params: [String: Any]?) -> UIViewController? {
        getCacheViewController(discoverTarget, action: "bannerDetailViewController:", module: discoverModule, params: params)
    }
}
