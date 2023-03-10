//
//  DBManager+Query.swift
//  YoDatabase
//
//  Created by Condy on 2020/12/1.
//

import Foundation
import WCDBSwift

public extension DBManager {
    /// 查询数据
    /// - Parameters:
    ///   - fromTable: 表名
    ///   - on: 需要查询字段
    ///   - where: 符合的条件
    ///   - orderBy: 排序的方式
    ///   - limit: 查询的个数
    ///   - offset: 从第几个开始查询
    func query<T: TableDecodable>(fromTable table: String,
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
        } catch let error {
            debugPrint("query error \(error.localizedDescription)")
        }
        return list
    }
    
    /// 查询单条数据
    /// - Parameters:
    ///   - fromTable: 表名
    ///   - on: 需要查询字段
    ///   - where: 符合的条件
    ///   - orderBy: 排序的方式
    ///   - offset: 从第几个开始查询
    func queryOne<T: TableDecodable>(fromTable table: String,
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
                                             fromTable:table,
                                             where: condition,
                                             orderBy: orderList,
                                             offset: offset)
        } catch let error {
            debugPrint("query error \(error.localizedDescription)")
        }
        return object
    }
}
