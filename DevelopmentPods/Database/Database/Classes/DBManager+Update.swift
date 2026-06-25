//
//  DBManager+Update.swift
//  YoDatabase
//
//  Created by yangKJ on 2020/12/1.
//

import Foundation
import WCDBSwift

public extension DBManager {
    /// 更新数据
    /// - Parameters:
    ///   - table: 表名
    ///   - with: 更新对象
    ///   - on: 需要更新字段
    ///   - where: 符合更新的条件
    ///   - orderBy: 排序的方式
    ///   - limit: 更新的个数
    ///   - offset: 从第几个开始更新
    /// - Note: 安全修复：强制要求 where 条件非 nil。where: nil 会全表更新，是高危 SQL 误操作。
    func update<T: TableEncodable>(table: String,
                                   on propertyConvertibleList: [PropertyConvertible]? = nil,
                                   with object: T,
                                   where condition: Condition? = nil,
                                   orderBy orderList: [OrderBy]? = nil,
                                   limit: Limit? = nil,
                                   offset: Offset? = nil) throws {
        // 修复：where: nil 会导致全表更新。生产环境若需要全表更新，请显式传入全表 Condition 并加以注释
        guard condition != nil else {
            assert(false, "DBManager.update: where condition is nil, refusing to perform full-table update. Pass an explicit Condition.")
            debugPrint("DBManager.update safety guard: where condition is nil, refusing to perform full-table update.")
            throw DBError.whereConditionRequired(operation: "update")
        }
        do {
            var temp: [PropertyConvertible] = []
            if propertyConvertibleList == nil || propertyConvertibleList!.isEmpty {
                temp = T.Properties.all
            } else {
                temp = propertyConvertibleList!
            }
            try dataBase?.update(table: table,
                                 on: temp,
                                 with: object,
                                 where: condition,
                                 orderBy: orderList,
                                 limit: limit,
                                 offset: offset)
        } catch let error {
            debugPrint(" update obj error \(error.localizedDescription)")
            // 已经是 DBError 时不再包装，避免重复套娃
            if let dbError = error as? DBError {
                throw dbError
            }
            throw DBError.updateFailed(underlying: error)
        }
    }
}