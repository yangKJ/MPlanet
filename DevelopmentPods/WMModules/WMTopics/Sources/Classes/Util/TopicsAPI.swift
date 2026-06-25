//
//  TopicsAPI.swift
//  WMTopics
//
//  Created by Condy on 2024/5/24.
//

import Foundation
import FeatBox

/// 主题/帖子接口枚举
enum TopicsAPI {
    /// 列表（type: 最新/热门/我的关注）
    case list(type: String)
    /// 详情
    case detail(id: Int)
}

extension TopicsAPI: NetworkAPI {

    var ip: APIHost {
        return Environment.host
    }

    var path: APIPath {
        switch self {
        case .list(let type):
            return "topics/\(type)/json"
        case .detail(let id):
            return "topics/detail/\(id)/json"
        }
    }

    var method: APIMethod {
        return .get
    }

    var parameters: APIParameters? {
        return nil
    }

    var plugins: APIPlugins {
        let loading = NetworkLoadingPlugin(options: .init(delay: 0.5))
        return [loading]
    }

    var stubBehavior: APIStubBehavior {
        return .delayed(seconds: 0.2)
    }

    var sampleData: Data {
        switch self {
        case .list:
            return Res.jsonData("TopicsList", forResource: "WMTopics") ?? Data()
        case .detail:
            return Res.jsonData("TopicDetail", forResource: "WMTopics") ?? Data()
        }
    }
}
