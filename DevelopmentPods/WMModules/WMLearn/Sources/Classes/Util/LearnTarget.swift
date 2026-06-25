//
//  LearnTarget.swift
//  WMLearn
//
//  Created by Condy on 2024/6/24.
//

import UIKit
import FeatBox

/// 配置 `Target` 供外界组件调用
///
/// CTMediator 反射约定：
/// - 类名：`LearnTarget`
/// - 模块名：`WMLearn`
/// - Action 命名：`Action_xxx(_:)` 形式，必须加 `@objc`
@objc public final class LearnTarget: NSObject {

    /// 学习区首页（无参）
    @objc public func Action_viewController(_ params: [String: Any]?) -> UIViewController {
        return LearnViewController()
    }

    /// 分类课程列表（params: categoryId）
    @objc public func Action_categoryViewController(_ params: [String: Any]?) -> UIViewController {
        let categoryId = params?["categoryId"] as? Int ?? 0
        let vc = LearnCategoryViewController()
        vc.categoryId = categoryId
        return vc
    }

    /// 课程详情（params: courseId）
    @objc public func Action_courseViewController(_ params: [String: Any]?) -> UIViewController {
        let courseId = params?["courseId"] as? Int ?? 0
        let vc = LearnCourseViewController()
        vc.courseId = courseId
        return vc
    }

    /// 世界排行榜（无参）
    @objc public func Action_rankingViewController(_ params: [String: Any]?) -> UIViewController {
        return LearnRankingViewController()
    }

    /// 视频赔价榜（params: categoryId）
    @objc public func Action_videoRankingViewController(_ params: [String: Any]?) -> UIViewController {
        let categoryId = params?["categoryId"] as? Int ?? 0
        let vc = LearnVideoRankingViewController()
        vc.categoryId = categoryId
        return vc
    }
}
