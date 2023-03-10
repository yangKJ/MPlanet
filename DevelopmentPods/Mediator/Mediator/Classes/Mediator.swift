//
//  Mediator.swift
//  Mediator
//
//  Created by Condy on 2020/12/28.
//

import Foundation
import Rickenbacker

/// 基础组件
extension Mediator {
    /// 发现组件
    public static func Discover_viewController() -> UIViewController? {
        performTarget("DiscoverTarget", action: "setupDiscoverViewController", module: "WMDiscover") as? UIViewController
    }
    /// 钱包组件
    public static func Wallet_viewController() -> UIViewController? {
        performTarget("WalletTarget", action: "setupWalletViewController", module: "WMWallet") as? UIViewController
    }
    /// 我的组件
    public static func Mine_viewController(userId: String?) -> UIViewController? {
        performTarget("MineTarget", action: "setupMineViewController:", module: "WMMine", params: ["userId": userId]) as? UIViewController
    }
}

/// 组件之间访问
extension Mediator {
    
}
