//
//  Topic.swift
//  WMTopics
//
//  Created by Condy on 2024/5/24.
//  主题/帖子模型
//

import Foundation
import SmartCodable
import FeatBox

/// 主题/帖子
struct Topic: SmartCodableX {

    var id: Int?
    var userId: Int?
    /// 用户名
    var username: String?
    /// 用户头像
    var userAvatar: String?
    /// 帖子标题
    var title: String?
    /// 帖子内容
    var content: String?
    /// 配图列表
    var imageUrls: [String]?
    /// 点赞数
    var likeCount: Int?
    /// 评论数
    var commentCount: Int?
    /// 创建时间
    var createTime: String?
    /// 评论列表（仅详情接口返回）
    var comments: [Comment]?

    static func mappingForKey() -> [SmartKeyTransformer]? {
        return [
            CodingKeys.userAvatar <--- ["user_avatar", "avatar", "avatarPath"],
            CodingKeys.imageUrls <--- ["image_urls", "images", "imagePaths"],
            CodingKeys.likeCount <--- ["like_count", "likes"],
            CodingKeys.commentCount <--- ["comment_count", "comments"],
            CodingKeys.createTime <--- ["create_time", "time", "createdAt"],
            CodingKeys.username <--- ["user_name", "userName"]
        ]
    }
}

/// 评论
struct Comment: SmartCodableX {

    var id: Int?
    var userId: Int?
    var username: String?
    var userAvatar: String?
    var content: String?
    var likeCount: Int?
    var createTime: String?

    static func mappingForKey() -> [SmartKeyTransformer]? {
        return [
            CodingKeys.userAvatar <--- ["user_avatar", "avatar", "avatarPath"],
            CodingKeys.likeCount <--- ["like_count", "likes"],
            CodingKeys.createTime <--- ["create_time", "time", "createdAt"],
            CodingKeys.username <--- ["user_name", "userName"]
        ]
    }
}
