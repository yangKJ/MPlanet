//
//  LearnCourse.swift
//  WMLearn
//
//  Created by Condy on 2024/6/24.
//

import Foundation
import SmartCodable
import FeatBox

/// 课程章节
struct LearnCourseChapter: SmartCodableX {

    /// 章节标题「第1课：认识钢琴键盘」
    var title: String?
    /// 章节时长「18:20」
    var duration: String?
    /// 视频 URL
    var videoUrl: String?
}

/// 课程
struct LearnCourse: SmartCodableX {

    var id: Int?
    /// 所属分类 ID
    var categoryId: Int?
    /// 课程标题
    var title: String?
    /// 讲师姓名
    var teacher: String?
    /// 价格（元）
    var price: Double?
    /// 封面图 URL
    var coverImage: String?
    /// 课程介绍
    var intro: String?
    /// 课程总时长「12小时30分」
    var duration: String?
    /// 学习人数
    var studentCount: Int?
    /// 评分 0~5
    var rating: Double?
    /// 章节列表
    var chapterList: [LearnCourseChapter]?

    static func mappingForKey() -> [SmartKeyTransformer]? {
        return [
            CodingKeys.chapterList <--- ["chapterList", "chapter_list"],
        ]
    }
}
