//
//  DBManager+Insert.swift
//  YoDatabase
//
//  Created by yangKJ on 2020/12/1.
//

import Foundation
import WCDBSwift

public extension DBManager {
    /// 增加数据
    /// - Parameters:
    ///   - intoTable: 表名
    ///   - objects: 需要插入的对象，可以是数组，也可以传入一个或多个对象
    ///   - on: 需要插入的字段
    func insert<T: TableEncodable>(intoTable table: String,
                                   objects: [T],
                                   on propertyConvertibleList: [PropertyConvertible]? = nil) throws {
        do {
            try dataBase?.insert(objects, on: propertyConvertibleList, intoTable: table)
        } catch {
            debugPrint(" insert obj error \(error.localizedDescription)")
            throw DBError.insertFailed(underlying: error)
        }
    }
    /// 增加或者更新数据
    /// - Parameters:
    ///   - intoTable: 表名
    ///   - objects: 需要插入的对象，可以是数组，也可以传入一个或多个对象
    ///   - on: 需要插入的字段
    func insertOrReplace<T: TableEncodable>(intoTable table: String,
                                            objects: [T],
                                            on propertyConvertibleList: [PropertyConvertible]? = nil) throws {
        do {
            try dataBase?.insertOrReplace(objects, on: propertyConvertibleList, intoTable: table)
        } catch {
            debugPrint(" insert obj error \(error.localizedDescription)")
            throw DBError.insertFailed(underlying: error)
        }
    }

    /// 批量插入数据，使用事务包裹。失败时整个事务回滚。
    /// - Parameters:
    ///   - objects: 需要插入的对象数组
    ///   - intoTable: 表名
    func insertBatch(_ objects: [TableEncodable], intoTable table: String) throws {
        guard !objects.isEmpty else {
            return
        }
        do {
            try dataBase?.run(transaction: {
                for obj in objects {
                    try dataBase?.insert(obj, intoTable: table)
                }
            })
        } catch {
            debugPrint(" insertBatch error \(error.localizedDescription)")
            throw DBError.insertBatchFailed(underlying: error)
        }
    }
}