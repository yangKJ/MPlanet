//
//  DiscoverVideoRanking.swift
//  WMDiscover
//
//  Created by UI Designer on 2024/5/24.
//  视频赔价榜模型：横向滚动的视频缩略图
//

import Foundation
import SmartCodable
import FeatBox

/// 视频榜单项
struct DiscoverVideoRanking: SmartCodableX {

    var id: Int?
    /// 视频标题
    var title: String?
    /// 封面图
    var imagePath: String?
    /// 作者
    var author: String?
    /// 播放数
    var playCount: Int?
    /// 排名
    var rank: Int?
    /// 排序
    var sort: Int?
}
