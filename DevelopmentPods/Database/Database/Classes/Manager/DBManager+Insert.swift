//
//  DBManager+Insert.swift
//  YoDatabase
//
//  Created by Condy on 2020/12/1.
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
                                   on propertyConvertibleList: [PropertyConvertible]? = nil) {
        do {
            try dataBase?.insert(objects: objects, on: propertyConvertibleList, intoTable: table)
        } catch let error {
            debugPrint(" insert obj error \(error.localizedDescription)")
        }
    }
    /// 增加或者更新数据
    /// - Parameters:
    ///   - intoTable: 表名
    ///   - objects: 需要插入的对象，可以是数组，也可以传入一个或多个对象
    ///   - on: 需要插入的字段
    func insertOrReplace<T: TableEncodable>(intoTable table: String,
                                            objects: [T],
                                            on propertyConvertibleList: [PropertyConvertible]? = nil) {
        do {
            try dataBase?.insertOrReplace(objects: objects, on: propertyConvertibleList, intoTable: table)
        } catch let error {
            debugPrint(" insert obj error \(error.localizedDescription)")
        }
    }

}
