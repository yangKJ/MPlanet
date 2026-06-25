//
//  LearnAPI.swift
//  WMLearn
//
//  Created by Condy on 2024/6/24.
//

import Foundation
import FeatBox

/// 学习区接口枚举
enum LearnAPI {
    /// 6 大分类
    case categories
    /// 分类下课程列表
    case courses(categoryId: Int)
    /// 课程详情
    case courseDetail(courseId: Int)
    /// 世界排行榜
    case ranking
    /// 视频赔价榜
    case videos(categoryId: Int)
}

extension LearnAPI: NetworkAPI {

    var ip: APIHost {
        return Environment.host
    }

    var path: APIPath {
        switch self {
        case .categories:
            return "learn/categories/json"
        case .courses:
            return "learn/courses/json"
        case .courseDetail:
            return "learn/courseDetail/json"
        case .ranking:
            return "learn/ranking/json"
        case .videos:
            return "learn/videos/json"
        }
    }

    var method: APIMethod {
        switch self {
        case .courseDetail:
            return .post
        default:
            return .get
        }
    }

    var parameters: APIParameters? {
        switch self {
        case .courses(let categoryId):
            return ["categoryId": categoryId]
        case .courseDetail(let courseId):
            return ["courseId": courseId]
        case .videos(let categoryId):
            return ["categoryId": categoryId]
        default:
            return nil
        }
    }

    var plugins: APIPlugins {
        // 简单 loading 插件，delay 0.5s 触发后自动隐藏
        let loading = NetworkLoadingPlugin(options: .init(delay: 0.5))
        return [loading]
    }

    var stubBehavior: APIStubBehavior {
        // 学习区全部走 mock JSON，使用 .delayed 模拟 0.2s 网络延迟
        switch self {
        case .categories, .ranking, .videos:
            return .delayed(seconds: 0.2)
        case .courses, .courseDetail:
            return .delayed(seconds: 0.2)
        }
    }

    var sampleData: Data {
        switch self {
        case .categories:
            // 修复：必须显式传 forResource: "WMLearn"，否则 FeatBox.bundle 不存在返回空 Data
            return Res.jsonData("LearnCategories", forResource: "WMLearn") ?? Data()
        case .courses, .courseDetail:
            return Res.jsonData("LearnCourses", forResource: "WMLearn") ?? Data()
        case .ranking:
            return Res.jsonData("LearnRanking", forResource: "WMLearn") ?? Data()
        case .videos:
            return Res.jsonData("LearnVideos", forResource: "WMLearn") ?? Data()
        }
    }
}
