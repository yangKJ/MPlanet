//
//  InstalledApp.swift
//  ProductLib
//
//  Created by Condy on 2024/4/19.
//

import Foundation

/// 判断系统是否安装某个App
public enum InstalledApp: String {
    case wechat = "wechat://"
}

extension InstalledApp {

    /// 是否已安装(实例属性,等价于之前的 `isInstallationed()`)
    public var isInstalled: Bool {
        guard let url = URL(string: self.rawValue) else {
            return false
        }
        if UIApplication.shared.canOpenURL(url) {
            return true
        }
        return false
    }
}
