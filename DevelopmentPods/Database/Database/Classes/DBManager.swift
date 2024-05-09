//
//  DatabaseManager.swift
//  YoDatabase
//
//  Created by Condy on 2020/12/1.
//

///`wcdb`数据库文档
/// https://juejin.cn/post/6844904117446377485#heading-61
/// https://github.com/Tencent/wcdb/wiki/Swift-%E5%85%B3%E4%BA%8E%20WCDB%20Swift

import Foundation
import WCDBSwift

public struct DBPath {
    static let domains = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    /// 默认数据库路径
    static let dbPath = (DBPath.domains.last ?? "") + "/Plant/YoDatabase.db"
}

public struct DBManager {
    public static let shared = DBManager()
    
    let dataBasePath = URL(fileURLWithPath: DBPath.dbPath)
    public var dataBase: Database?
    private init() {
        dataBase = createDatabase()
    }
    
    /// 创建数据库
    private func createDatabase() -> Database {
        debugPrint("🎷数据库路径:\(dataBasePath.absoluteString)")
        return Database(at: dataBasePath)
    }
    /// 创建数据表
    public func createTable<T: TableDecodable>(_ table: String, of type: T.Type) -> Void {
        do {
            try dataBase?.create(table: table, of: type)
        } catch let error {
            debugPrint("create table error \(error.localizedDescription)")
        }
    }
    /// 删除数据表
    public func dropTable(_ table: String) -> Void {
        do {
            try dataBase?.drop(table: table)
        } catch let error {
            debugPrint("drop table error \(error)")
        }
    }
    /// 删除所有与该数据库相关的文件
    public func removeDbFile() -> Void {
        do {
            try dataBase?.close(onClosed: {
                try dataBase?.removeFiles()
            })
        } catch let error {
            debugPrint("not close db \(error)")
        }
    }
}
