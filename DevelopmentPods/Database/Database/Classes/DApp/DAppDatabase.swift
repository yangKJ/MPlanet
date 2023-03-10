//
//  DAppDatabase.swift
//  Pods-WMDatabaseModules_Example
//
//  Created by yangkejun on 2021/12/7.
//

import UIKit
import WCDBSwift

/// 字段详解见文档：https://github.com/wamiCompany/Database/blob/master/Tables/DApp.numbers

public struct DAppDatabase: TableCodable {
    // 表名
    public static let DApp_table = "DApp_table"
    
    public var ID: Int?
    public var title: String?
    public var subTitle: String?
    public var DAppUrl: String?
    public var rpcUrl: String?
    public var imageUrl: String?
    public var inetrviewed: Bool?
    public var chain: String?
    public var chainID: Int?
    public var collect: Bool?
    public var history: String?
    public var searchHistory: String?
    
    public init() { }
    
    public enum CodingKeys: String, CodingTableKey {
        public typealias Root = DAppDatabase
        public static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case ID
        case title
        case subTitle
        case DAppUrl
        case rpcUrl
        case imageUrl
        case inetrviewed
        case chain
        case chainID
        case collect
        case history
        case searchHistory
        
        public static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                .ID: ColumnConstraintBinding(isPrimary: true, isAutoIncrement: true),
            ]
        }
    }
}

public extension DAppDatabase {
    
    /// 插入或更新数据
    static func insertOrUpdate(_ object: DAppDatabase) {
        let obj: DAppDatabase? = DBManager.shared.queryOne(fromTable: DAppDatabase.DApp_table,
                                                           where: DAppDatabase.Properties.DAppUrl == object.DAppUrl!)
        if var obj = obj {
            obj.ID = (object.ID != nil) ? object.ID : obj.ID
            obj.title = (object.title != nil) ? object.title : obj.title
            obj.subTitle = (object.subTitle != nil) ? object.subTitle : obj.subTitle
            obj.DAppUrl = (object.DAppUrl != nil) ? object.DAppUrl : obj.DAppUrl
            obj.rpcUrl = (object.rpcUrl != nil) ? object.rpcUrl : obj.rpcUrl
            obj.imageUrl = (object.imageUrl != nil) ? object.imageUrl : obj.imageUrl
            obj.inetrviewed = (object.inetrviewed != nil) ? object.inetrviewed : obj.inetrviewed
            obj.chain = (object.chain != nil) ? object.chain : obj.chain
            obj.chainID = (object.chainID != nil) ? object.chainID : obj.chainID
            obj.collect = (object.collect != nil) ? object.collect : obj.collect
            obj.history = (object.history != nil) ? object.history : obj.history
            obj.searchHistory = (object.searchHistory != nil) ? object.searchHistory : obj.searchHistory
            DBManager.shared.update(table: DAppDatabase.DApp_table,
                                    with: obj,
                                    where: DAppDatabase.Properties.ID == object.ID!)
        } else {
            DBManager.shared.insert(intoTable: DAppDatabase.DApp_table, objects: [object])
        }
    }
}
