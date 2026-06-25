//
//  DiscoverQuickEntries.swift
//  WMDiscover
//
//  Created by UI Designer on 2024/5/24.
//  6 宫格学习入口（钢琴 / 作曲 / 声乐 / 吉他 / 贝斯 / 混音）的默认数据
//

import Foundation
import UIKit

/// 学习区 6 宫格默认数据
/// 当接口失败或本地 mock 时使用 SF Symbols 图标快速渲染
struct DiscoverQuickEntryItem {

    /// 唯一标识（对应 DiscoverQuickEntry.id）
    let id: Int
    /// 显示标题
    let title: String
    /// SF Symbol 名称
    let iconName: String

    /// 默认 6 项数据，按 sort 排序
    static let defaults: [DiscoverQuickEntryItem] = [
        .init(id: 1, title: "钢琴",   iconName: "pianokeys"),
        .init(id: 2, title: "作曲",   iconName: "music.note.list"),
        .init(id: 3, title: "声乐",   iconName: "mic.fill"),
        .init(id: 4, title: "吉他",   iconName: "guitars"),
        .init(id: 5, title: "贝斯",   iconName: "music.quarternote.3"),
        .init(id: 6, title: "混音",   iconName: "slider.horizontal.3"),
    ]
}
