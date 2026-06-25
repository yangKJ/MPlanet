//
//  DiscoverQuickEntry.swift
//  WMDiscover
//
//  Created by UI Designer on 2024/5/24.
//  6 宫格学习区入口模型：钢琴 / 作曲 / 声乐 / 吉他 / 贝斯 / 混音
//

import Foundation
import SmartCodable
import FeatBox

/// 6 宫格学习区入口数据
struct DiscoverQuickEntry: SmartCodableX {

    var id: Int?
    /// 入口名（钢琴、作曲、声乐、吉他、贝斯、混音）
    var title: String?
    /// SF Symbol 名称
    var iconName: String?
    /// 排序
    var sort: Int?

    static func mappingForKey() -> [SmartKeyTransformer]? {
        return [
            CodingKeys.iconName <--- ["icon", "icon_name"],
        ]
    }
}
