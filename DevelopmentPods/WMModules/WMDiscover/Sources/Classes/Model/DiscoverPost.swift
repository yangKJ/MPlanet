//
//  DiscoverPost.swift
//  WMDiscover
//
//  Created by UI Designer on 2024/5/24.
//  最新帖子流模型
//

import Foundation
import SmartCodable
import FeatBox

/// 帖子流单项
struct DiscoverPost: SmartCodableX {

    var id: Int?
    var userId: Int?
    /// 用户名
    var userName: String?
    /// 头像
    var avatarPath: String?
    /// 文本内容
    var content: String?
    /// 配图
    var imagePath: String?
    /// 点赞数
    var likeCount: Int?
    /// 评论数
    var commentCount: Int?
    /// 时间
    var createTime: String?
    /// 排序
    var sort: Int?
}
