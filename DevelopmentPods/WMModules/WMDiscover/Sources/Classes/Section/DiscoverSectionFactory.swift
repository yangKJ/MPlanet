//
//  DiscoverSectionFactory.swift
//  WMDiscover
//
//  Created by UI Designer on 2024/5/24.
//  Home Tab section 工厂：6 宫格、视频榜、帖子流
//

import Foundation
import UIKit
import FeatBox

/// Home Tab section 工厂
enum DiscoverSectionFactory {

    /// 6 宫格学习区入口 section
    static func quickEntriesSection() -> BaseTableViewSectionable? {
        let section = BaseTableViewHeaderFooterSection(cells: [])
        var cell = DiscoverQuickEntriesCellViewModel()
        // 修复：原 cellHeight=200 含 80pt 底部空白。改为 140pt 紧凑布局。
        cell.cellHeight = 140
        section.cells = [cell]
        return section
    }

    /// 视频赔价榜入口 section
    static func videoRankingSection(items: [DiscoverVideoRanking]) -> BaseTableViewSectionable? {
        let section = DiscoverSectionHeaderViewModel(cells: [], title: "视频赔价榜", moreTitle: "更多")
        section.sectionHeaderViewType = DiscoverSectionHeaderView.self
        section.sectionHeaderHeight = 36
        var cell = DiscoverVideoRankingCellViewModel()
        cell.datasource = items
        cell.cellHeight = 150
        section.cells = [cell]
        return section
    }

    /// 帖子流 section
    static func postsSection(items: [DiscoverPost]) -> BaseTableViewSectionable? {
        let section = DiscoverSectionHeaderViewModel(cells: [], title: "最新帖子", moreTitle: "更多")
        section.sectionHeaderViewType = DiscoverSectionHeaderView.self
        section.sectionHeaderHeight = 36
        var cell = DiscoverPostCellViewModel()
        cell.datasource = items
        section.cells = [cell]
        return section
    }
}
