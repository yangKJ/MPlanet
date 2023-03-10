//
//  DBManager+Update.swift
//  YoDatabase
//
//  Created by Condy on 2020/12/1.
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
    func update<T: TableEncodable>(table: String,
                                   on propertyConvertibleList: [PropertyConvertible]? = nil,
                                   with object: T,
                                   where condition: Condition? = nil,
                                   orderBy orderList: [OrderBy]? = nil,
                                   limit: Limit? = nil,
                                   offset: Offset? = nil) {
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
        }
    }
}
