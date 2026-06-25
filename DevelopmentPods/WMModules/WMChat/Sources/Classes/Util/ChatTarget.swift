//
//  ChatTarget.swift
//  WMChat
//
//  Created by Condy on 2024/5/24.
//

import UIKit
import FeatBox

/// 配置 `Target` 供外界组件调用
///
/// CTMediator 反射约定：
/// - 类名：`ChatTarget`
/// - 模块名：`WMChat`
/// - Action 命名：`Action_xxx(_:)` 形式，必须加 `@objc`
@objc public final class ChatTarget: NSObject {

    /// 消息列表（无参）
    @objc public func Action_viewController(_ params: [String: Any]?) -> UIViewController {
        return ChatListViewController()
    }
}
