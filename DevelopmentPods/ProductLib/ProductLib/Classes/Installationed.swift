//
//  Installationed.swift
//  ProductLib
//
//  Created by Condy on 2024/4/19.
//

import Foundation

/// 判断系统是否安装某个App
public enum Installationed: String {
    case wechat = "wechat://"
}

extension Installationed {
    
    public func isInstallationed() -> Bool {
        guard let url = URL(string: self.rawValue) else {
            return false
        }
        if UIApplication.shared.canOpenURL(url) {
            return true
        }
        return false
    }
}
