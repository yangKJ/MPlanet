//
//  MineAPI.swift
//  Alamofire
//
//  Created by Condy on 2023/6/6.
//

import Foundation
import RxNetworks
import FeatBox

enum MineAPI {
    case mine(userId: String?)
}

extension MineAPI: NetworkAPI {
    
    var ip: APIHost {
        return Environment.host
    }
    
    var path: APIPath {
        switch self {
        case .mine(let name):
            return "/users/" + (name ?? "")
        }
    }
    
    var method: APIMethod {
        switch self {
        case .mine:
            return .get
        }
    }
    
    var parameters: APIParameters? {
        switch self {
        case .mine(let userId):
            return nil
        }
    }
    
    var plugins: APIPlugins {
        switch self {
        case .mine:
            let loading = NetworkLoadingPlugin.init(options: .init(delay: 0.5, autoHide: false))
            return [loading]
        default:
            let loading = NetworkLoadingPlugin.init(options: .init(delay: 0.5))
            return [loading]
        }
    }
    
    var stubBehavior: APIStubBehavior {
        switch self {
        case .mine:
            return .delayed(seconds: 0.2)
        default:
            return .never
        }
    }
    
    var sampleData: Data {
        switch self {
        case .mine:
            return Res.jsonData("User")
        }
    }
}
