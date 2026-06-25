//
//  DBManager+Delete.swift
//  YoDatabase
//
//  Created by yangKJ on 2020/12/1.
//

import Foundation
import WCDBSwift

public extension DBManager {
    /// 删除数据
    /// - Parameters:
    ///   - table: 表名
    ///   - where: 符合删除的条件
    ///   - orderBy: 排序的方式
    ///   - limit: 删除的个数
    ///   - offset: 从第几个开始删除
    /// - Note: 安全修复：强制要求 where 条件非 nil。where: nil 会全表删除。
    func delete(fromTable table: String,
                where condition: Condition? = nil,
                orderBy orderList: [OrderBy]? = nil,
                limit: Limit? = nil,
                offset: Offset? = nil) throws {
        // 修复：where: nil 会导致全表删除，是高危 SQL 误操作。
        guard condition != nil else {
            assert(false, "DBManager.delete: where condition is nil, refusing to perform full-table delete. Pass an explicit Condition.")
            debugPrint("DBManager.delete safety guard: where condition is nil, refusing to perform full-table delete.")
            throw DBError.whereConditionRequired(operation: "delete")
        }
        do {
            try dataBase?.delete(fromTable: table,
                                 where: condition,
                                 orderBy: orderList,
                                 limit: limit,
                                 offset: offset)
        } catch {
            debugPrint("delete error \(error.localizedDescription)")
            // 已经是 DBError 时不再包装，避免重复套娃
            if let dbError = error as? DBError {
                throw dbError
            }
            throw DBError.deleteFailed(underlying: error)
        }
    }
}