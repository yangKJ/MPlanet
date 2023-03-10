//
//  DBManager+Delete.swift
//  YoDatabase
//
//  Created by Condy on 2020/12/1.
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
    func delete(fromTable table: String,
                where condition: Condition? = nil,
                orderBy orderList: [OrderBy]? = nil,
                limit: Limit? = nil,
                offset: Offset? = nil) {
        do {
            try dataBase?.delete(fromTable: table,
                                 where: condition,
                                 orderBy: orderList,
                                 limit: limit,
                                 offset: offset)
        } catch let error {
            debugPrint("delete error \(error.localizedDescription)")
        }
    }
}
