//
//  MinePostsDetail.swift
//  WMMine
//
//  Created by Condy on 2023/6/6.
//

import Foundation
import SmartCodable

struct MinePostsDetail: SmartCodableX {
    var id: String?
    var title: String?
    var content: String?
    var time: TimeInterval?
    var userId: Int?
    var userName: String?
    var userAvatar: String?
    var imageUrls: [String]?
    var likeCount: Int?
    var commentCount: Int?
    var createTime: String?
}
