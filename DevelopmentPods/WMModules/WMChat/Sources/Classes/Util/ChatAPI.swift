//
//  ChatAPI.swift
//  WMChat
//
//  Created by Condy on 2024/5/24.
//

import Foundation
import FeatBox

/// 消息接口枚举
enum ChatAPI {
    /// 会话列表
    case sessions
}

extension ChatAPI: NetworkAPI {

    var ip: APIHost {
        return Environment.host
    }

    var path: APIPath {
        return "chat/sessions/json"
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
        return Res.jsonData("ChatSessions", forResource: "WMChat") ?? Data()
    }
}
