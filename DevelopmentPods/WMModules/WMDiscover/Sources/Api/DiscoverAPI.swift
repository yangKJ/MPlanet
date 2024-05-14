//
//  DiscoverAPI.swift
//  WMWallet
//
//  Created by Condy on 2020/12/28.
//

import FeatBox
import RxNetworks

enum DiscoverAPI {
    /// 发现列表数据
    case banner
    /// 发现首页
    case discoverHome
    /// 详情
    case detail(Banner)
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
        default:
            return .delayed(seconds: 2.0)
        }
    }
    
    var sampleData: Data {
        switch self {
        case .banner:
            return Res.jsonData("Banner")
        case .discoverHome:
            return Res.jsonData("DiscoverHome")
        case .detail(let banner):
            return Res.jsonData("BannerDetail")
        }
    }
}
