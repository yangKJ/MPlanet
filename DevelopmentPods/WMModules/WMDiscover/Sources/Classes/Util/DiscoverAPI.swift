//
//  DiscoverAPI.swift
//  WMWallet
//
//  Created by Condy on 2020/12/28.
//

import FeatBox

enum DiscoverAPI {
    /// 发现列表数据
    case banner
    /// 发现首页
    case discoverHome
    /// 详情
    case detail(Banner)
    /// 6 宫格学习区入口
    case quickEntries
    /// 视频赔价榜
    case videoRanking
    /// 最新帖子流
    case posts
}

extension DiscoverAPI: NetworkAPI {

    var ip: APIHost {
        return Environment.host
    }

    var path: APIPath {
        switch self {
        case .banner:
            return "banner/json"
        case .discoverHome:
            return "discover/json"
        case .detail:
            return "detail/json"
        case .quickEntries:
            return "quickEntries/json"
        case .videoRanking:
            return "videoRanking/json"
        case .posts:
            return "posts/json"
        }
    }

    var method: APIMethod {
        switch self {
        case .banner:
            return .get
        case .discoverHome:
            return .get
        case .detail:
            return .post
        case .quickEntries:
            return .get
        case .videoRanking:
            return .get
        case .posts:
            return .get
        }
    }

    var parameters: APIParameters? {
        switch self {
        case .banner:
            return nil
        case .discoverHome:
            return nil
        case .detail(let banner):
            return ["id": banner.id ?? ""]
        case .quickEntries:
            return nil
        case .videoRanking:
            return nil
        case .posts:
            return nil
        }
    }

    var plugins: APIPlugins {
        switch self {
        case .detail(let banner):
            let loading = NetworkLoadingPlugin.init(options: .init(delay: 0.5, autoHide: false))
            return [loading]
        default:
            let loading = NetworkLoadingPlugin.init(options: .init(delay: 0.5))
            return [loading]
        }
    }

    var stubBehavior: APIStubBehavior {
        switch self {
        case .banner:
            return .delayed(seconds: 0.2)
        case .quickEntries:
            return .delayed(seconds: 0.2)
        case .videoRanking:
            return .delayed(seconds: 0.2)
        case .posts:
            return .delayed(seconds: 0.2)
        default:
            return .delayed(seconds: 2.0)
        }
    }

    var sampleData: Data {
        switch self {
        case .banner:
            // 修复：原 Res.jsonData("Banner") 默认 forResource="FeatBox"，
            // FeatBox.bundle 不存在导致永远返回空 Data。改为显式传 "WMDiscover"。
            return Res.jsonData("Banner", forResource: "WMDiscover") ?? Data()
        case .discoverHome:
            return Res.jsonData("DiscoverHome", forResource: "WMDiscover") ?? Data()
        case .detail(let banner):
            return Res.jsonData("BannerDetail", forResource: "WMDiscover") ?? Data()
        case .quickEntries:
            return Res.jsonData("QuickEntries", forResource: "WMDiscover") ?? Data()
        case .videoRanking:
            return Res.jsonData("VideoRanking", forResource: "WMDiscover") ?? Data()
        case .posts:
            return Res.jsonData("Posts", forResource: "WMDiscover") ?? Data()
        }
    }
}
