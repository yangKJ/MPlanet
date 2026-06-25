//
//  LearnUtil.swift
//  WMLearn
//
//  Created by Condy on 2024/6/24.
//

import UIKit
import FeatBox

/// WMLearn 模块基础信息
struct LearnUtil {
    /// 模块名（对应 resource_bundles key）
    static let moduleName = "WMLearn"
}

/// 资源加载辅助（显式指定 bundle 为 WMLearn，避免走 FeatBox 默认 bundle 找不到资源）
extension Res {

    static func image(_ named: String) -> UIImage {
        self.image(named, forResource: LearnUtil.moduleName)
    }

    static func jsonData(_ named: String) -> Data {
        self.jsonData(named, forResource: LearnUtil.moduleName) ?? Data()
    }

    static func text(_ string: String) -> String {
        self.text(string, forResource: LearnUtil.moduleName)
    }
}
