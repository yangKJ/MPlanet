//
//  LearnRanking.swift
//  WMLearn
//
//  Created by Condy on 2024/6/24.
//

import Foundation
import SmartCodable
import FeatBox

/// 世界排行榜用户
struct LearnRanking: SmartCodableX {

    /// 排名（1-based）
    var rank: Int?
    /// 用户名
    var name: String?
    /// 分数 0~100
    var score: Int?
    /// 头像 URL
    var avatar: String?
    /// 是否当前登录用户（用于高亮显示）
    var isCurrentUser: Bool?
}

/// 视频赔价榜（复用 WMDiscover 视频赔价榜的形态）
struct LearnVideoCard: SmartCodableX {

    var id: Int?
    var categoryId: Int?
    /// 视频标题
    var title: String?
    /// 上传者/讲师
    var teacher: String?
    /// 封面
    var coverImage: String?
    /// 播放数
    var playCount: Int?
    /// 点赞数
    var likeCount: Int?
    /// 时长「03:42」
    var duration: String?
}
