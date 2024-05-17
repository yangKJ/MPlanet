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
        performTarget(Mediator.discoverTarget, action: "getDiscoverViewControllerType", module: Mediator.discoverModule) as? UIViewController.Type
    }
    public static func walletViewControllerType() -> UIViewController.Type? {
        performTarget(Mediator.walletTarget, action: "getWalletViewControllerType", module: Mediator.walletModule) as? UIViewController.Type
    }
    public static func mineViewControllerType() -> UIViewController.Type? {
        performTarget(Mediator.mineTarget, action: "getMineViewControllerType", module: Mediator.mineModule) as? UIViewController.Type
    }
    
    /// 跳转到标签页
    public static func gotoTabBarIndex(with gotoObject: String?) -> Bool? {
        performTarget("AppMainTarget", action: "gotoTabBarIndex:", module: "AppMain", params: ["gotoObject": gotoObject]) as? Bool
    }
}

/// 基础组件
extension Mediator {
    /// 发现组件
    public static func Discover_viewController() -> UIViewController? {
        getCacheViewController(Mediator.discoverTarget, action: "setupDiscoverViewController", module: Mediator.discoverModule)
    }
    /// 钱包组件
    public static func Wallet_viewController() -> UIViewController? {
        getCacheViewController(Mediator.walletTarget, action: "setupWalletViewController", module: Mediator.walletModule)
    }
    /// 我的组件
    public static func Mine_viewController(userId: String?) -> UIViewController? {
        getCacheViewController(Mediator.mineTarget, action: "setupMineViewController:", module: Mediator.mineModule, params: ["userId": userId])
    }
}

/// 组件之间访问
extension Mediator {
    /// Banner详情
    public static func bannerDetailViewController(params: MediatorParams?) -> UIViewController? {
        getCacheViewController(Mediator.discoverTarget, action: "bannerDetailViewController:", module: Mediator.discoverModule, params: params)
    }
}
