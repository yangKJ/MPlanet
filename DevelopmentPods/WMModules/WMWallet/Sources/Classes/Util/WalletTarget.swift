//
//  WalletTarget.swift
//  WMWallet
//
//  Created by Condy on 2024/6/24.
//

import UIKit
import FeatBox

/// 配置 `Target` 供外界组件调用
///
/// CTMediator 反射约定：
/// - 类名：`WalletTarget`
/// - 模块名：`WMWallet`
/// - Action 命名：`Action_xxx(_:)` 形式，必须加 `@objc`
@objc public final class WalletTarget: NSObject {

    /// 钱包首页（无参）
    @objc public func Action_viewController(_ params: [String: Any]?) -> UIViewController {
        return WalletViewController()
    }
}