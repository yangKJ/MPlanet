//
//  TopicsTarget.swift
//  WMTopics
//
//  Created by Condy on 2024/5/24.
//

import UIKit
import FeatBox

/// 配置 `Target` 供外界组件调用
///
/// CTMediator 反射约定：
/// - 类名：`TopicsTarget`
/// - 模块名：`WMTopics`
/// - Action 命名：`Action_xxx(_:)` 形式，必须加 `@objc`
@objc public final class TopicsTarget: NSObject {

    /// 主题列表（无参）
    @objc public func Action_viewController(_ params: [String: Any]?) -> UIViewController {
        return TopicsViewController()
    }

    /// 帖子详情（params: id）
    @objc public func Action_detailViewController(_ params: [String: Any]?) -> UIViewController {
        let vc = TopicDetailViewController()
        vc.topicId = params?["id"] as? Int ?? 0
        return vc
    }
}
