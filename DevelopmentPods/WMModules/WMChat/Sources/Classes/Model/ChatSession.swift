//
//  ChatSession.swift
//  WMChat
//
//  Created by Condy on 2024/5/24.
//  会话模型
//

import Foundation
import SmartCodable
import FeatBox

/// 会话
struct ChatSession: SmartCodableX {

    var id: Int?
    var userId: Int?
    /// 用户名
    var username: String?
    /// 用户头像
    var avatar: String?
    /// 最后一条消息
    var lastMessage: String?
    /// 最后消息时间
    var lastTime: String?
    /// 未读消息数
    var unreadCount: Int?

    static func mappingForKey() -> [SmartKeyTransformer]? {
        return [
            CodingKeys.avatar <--- ["user_avatar", "avatarPath", "userAvatar"],
            CodingKeys.lastMessage <--- ["last_message", "message"],
            CodingKeys.lastTime <--- ["last_time", "time"],
            CodingKeys.unreadCount <--- ["unread_count"],
            CodingKeys.username <--- ["user_name", "userName"]
        ]
    }
}
