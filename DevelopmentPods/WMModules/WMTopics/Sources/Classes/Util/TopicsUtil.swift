//
//  TopicsUtil.swift
//  WMTopics
//
//  Created by Condy on 2024/5/24.
//

import UIKit
import FeatBox

/// WMTopics 模块基础信息
struct TopicsUtil {
    /// 模块名（对应 resource_bundles key）
    static let moduleName = "WMTopics"
}

/// 资源加载辅助（显式指定 bundle 为 WMTopics，避免走 FeatBox 默认 bundle 找不到资源）
extension Res {

    static func image(_ named: String) -> UIImage {
        self.image(named, forResource: TopicsUtil.moduleName)
    }

    static func jsonData(_ named: String) -> Data {
        self.jsonData(named, forResource: TopicsUtil.moduleName) ?? Data()
    }

    static func text(_ string: String) -> String {
        self.text(string, forResource: TopicsUtil.moduleName)
    }
}
