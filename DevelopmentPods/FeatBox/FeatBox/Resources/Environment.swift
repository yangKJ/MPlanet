//
//  Environment.swift
//  Alamofire
//
//  Created by Condy on 2023/9/13.
//

import Foundation

/// 配置环境参数
public struct Environment {
    public enum EnvironmentType {
        // 开发环境
        case develop
        // 正式环境
        case release
    }
    
    /// 需要修改环境，请改此次。测试完成之后记得改回去‼️‼️‼️
    /// 子模块如需单独测试，请记得在模块测试处修改此环境
    public static var environment = EnvironmentType.develop
}

extension Environment {
    
    public static var isProd: Bool {
        switch environment {
        case .develop:
            return false
        case .release:
            return true
        }
    }
    
    public static var host: String {
        switch environment {
        case .develop:
            return "https://api.github.com"
        case .release:
            return "https://www.httpbin.org"
        }
    }
}
