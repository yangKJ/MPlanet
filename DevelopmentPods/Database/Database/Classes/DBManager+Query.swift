//
//  DBManager+Query.swift
//  YoDatabase
//
//  Created by yangKJ on 2020/12/1.
//

import Foundation
import WCDBSwift

public extension DBManager {
    /// 性能修复：统一的数据库查询后台队列，避免主线程阻塞
    static let queryQueue = DispatchQueue(label: "com.mplanet.db.query",
                                          qos: .userInitiated,
                                          attributes: .concurrent)

    /// 查询数据
    /// - Parameters:
    ///   - fromTable: 表名
    ///   - on: 需要查询字段
    ///   - where: 符合的条件
    ///   - orderBy: 排序的方式
    ///   - limit: 查询的个数
    ///   - offset: 从第几个开始查询
    ///   - completion: 查询完成回调（已在后台队列中）。失败时返回 nil，调用方可通过 lastError 获取详细错误。
    func query<T: TableDecodable>(fromTable table: String,
                                  on propertyConvertibleList: [PropertyConvertible]? = nil,
                                  where condition: Condition? = nil,
                                  orderBy orderList: [OrderBy]? = nil,
                                  limit: Limit? = nil,
                                  offset: Offset? = nil,
                                  completion: @escaping ([T]?) -> Void) {
        // 性能修复：移到后台并发队列，避免主线程阻塞
        DBManager.queryQueue.async {
            var list: [T]?
            do {
                var temp: [PropertyConvertible] = []
                if propertyConvertibleList == nil || propertyConvertibleList!.isEmpty {
                    temp = T.Properties.all
                } else {
                    temp = propertyConvertibleList!
                }
                try list = dataBase?.getObjects(on: temp,
                                                fromTable: table,
                                                where: condition,
                                                orderBy: orderList,
                                                limit: limit,
                                                offset: offset)
            } catch {
                debugPrint("query error \(error.localizedDescription)")
            }
            completion(list)
        }
    }

    /// 查询数据 - 同步版（不推荐在主线程使用）
    /// - Note: 内部使用，调用方需自行保证不在主线程。
    func querySync<T: TableDecodable>(fromTable table: String,
                                      on propertyConvertibleList: [PropertyConvertible]? = nil,
                                      where condition: Condition? = nil,
                                      orderBy orderList: [OrderBy]? = nil,
                                      limit: Limit? = nil,
                                      offset: Offset? = nil) -> [T]? {
        var list: [T]?
        do {
            var temp: [PropertyConvertible] = []
            if propertyConvertibleList == nil || propertyConvertibleList!.isEmpty {
                temp = T.Properties.all
            } else {
                temp = propertyConvertibleList!
            }
            try list = dataBase?.getObjects(on: temp,
                                            fromTable: table,
                                            where: condition,
                                            orderBy: orderList,
                                            limit: limit,
                                            offset: offset)
        } catch {
            debugPrint("query error \(error.localizedDescription)")
        }
        return list
    }

    /// 查询单条数据 - 异步版
    func queryOne<T: TableDecodable>(fromTable table: String,
                                     on propertyConvertibleList: [PropertyConvertible]? = nil,
                                     where condition: Condition? = nil,
                                     orderBy orderList: [OrderBy]? = nil,
                                     offset: Offset? = nil,
                                     completion: @escaping (T?) -> Void) {
        DBManager.queryQueue.async {
            var object: T?
            do {
                var temp: [PropertyConvertible] = []
                if propertyConvertibleList == nil || propertyConvertibleList!.isEmpty {
                    temp = T.Properties.all
                } else {
                    temp = propertyConvertibleList!
                }
                try object = dataBase?.getObject(on: temp,
                                                 fromTable: table,
                                                 where: condition,
                                                 orderBy: orderList,
                                                 offset: offset)
            } catch {
                debugPrint("query error \(error.localizedDescription)")
            }
            completion(object)
        }
    }

    /// 查询单条数据 - 同步版
    func queryOneSync<T: TableDecodable>(fromTable table: String,
                                         on propertyConvertibleList: [PropertyConvertible]? = nil,
                                         where condition: Condition? = nil,
                                         orderBy orderList: [OrderBy]? = nil,
                                         offset: Offset? = nil) -> T? {
        var object: T?
        do {
            var temp: [PropertyConvertible] = []
            if propertyConvertibleList == nil || propertyConvertibleList!.isEmpty {
                temp = T.Properties.all
            } else {
                temp = propertyConvertibleList!
            }
            try object = dataBase?.getObject(on: temp,
                                             fromTable: table,
                                             where: condition,
                                             orderBy: orderList,
                                             offset: offset)
        } catch {
            debugPrint("query error \(error.localizedDescription)")
        }
        return object
    }
}