//
//  LearnCategory.swift
//  WMLearn
//
//  Created by Condy on 2024/6/24.
//

import Foundation
import SmartCodable
import FeatBox

/// 学习区 6 大分类
struct LearnCategory: SmartCodableX {

    var id: Int?
    /// 中文标题「钢琴」
    var title: String?
    /// 英文标题「Piano」
    var titleEn: String?
    /// SF Symbol icon 名（前端占位用）
    var icon: String?
    /// 该分类下课程数
    var courseCount: Int?
    /// 学习该分类的学员数
    var studentCount: Int?

    /// SF Symbol icon 名称 → UIImage（如果系统不支持则返回 nil）
    var iconImage: UIImage? {
        guard let name = icon else { return nil }
        if UIImage(systemName: name) != nil {
            return UIImage(systemName: name)
        }
        return nil
    }
}

/// 学习区分组类型（用于首页 Section 分类）
enum LearnGroupDetailType {
    /// 6 大分类宫格
    case category
    /// 视频赔价榜入口
    case videoRanking
}
