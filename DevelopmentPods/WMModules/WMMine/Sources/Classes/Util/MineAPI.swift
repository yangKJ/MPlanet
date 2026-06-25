//
//  MineAPI.swift
//  Alamofire
//
//  Created by Condy on 2023/6/6.
//

import Foundation
import FeatBox

enum MineAPI {
    case mine(userId: String?)
    case photos(userId: String?)
    case logout
}

extension MineAPI: NetworkAPI {
    
    var ip: APIHost {
        return Environment.host
    }
    
    var path: APIPath {
        switch self {
        case .mine(let name):
            return "/users/" + (name ?? "")
        case .photos:
            return "/photos"
        case .logout:
            return "/logout"
        }
    }
    
    var method: APIMethod {
        switch self {
        case .mine:
            return .get
        default:
            return .get
        }
    }
    
    var parameters: APIParameters? {
        switch self {
        case .mine(let userId):
            return nil
        default:
            return nil
        }
    }
    
    var plugins: APIPlugins {
        switch self {
        case .mine:
            let loading = NetworkLoadingPlugin.init(options: .init(delay: 0.5, autoHide: false))
            return [loading]
        case .logout:
            let loading = NetworkLoadingPlugin.init(options: .init(text: Res.text("退出登陆ing.."), delay: 0.5))
            return [loading]
        default:
            let loading = NetworkLoadingPlugin.init(options: .init(delay: 0.5))
            return [loading]
        }
    }
    
    var stubBehavior: APIStubBehavior {
        switch self {
        case .mine:
            // 修复：原 .never 走真网络 (https://api.github.com/users/yangKJ)，
            // GitHub API 触发 15s timeout 后 Observable emit error，
            // MineViewModel 里 `user.bind(to: users)` 走到 .error 分支
            // 触发 RxRelay 的 rxFatalErrorInDebug crash。
            // 改为 .delayed 走 sampleData（User.json），无网络无 timeout 无 crash。
            return .delayed(seconds: 0.2)
        case .photos:
            return .delayed(seconds: 0.2)
        default:
            return .never
        }
    }
    
    var sampleData: Data {
        switch self {
        case .mine:
            // 修复：原 Res.jsonData("User") 默认 forResource="FeatBox"，
            // FeatBox.bundle 不存在导致永远返回空 Data。改为显式传 "WMMine"。
            return Res.jsonData("User", forResource: "WMMine") ?? Data()
        case .photos:
            return Res.jsonData("Photos", forResource: "WMMine") ?? Data()
        default:
            return Data()
        }
    }
}
