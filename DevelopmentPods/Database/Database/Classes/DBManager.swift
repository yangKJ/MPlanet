//
//  DBManager.swift
//  YoDatabase
//
//  Created by yangKJ on 2020/12/1.
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
        do {
            dataBase = try createDatabase()
        } catch {
            // 初始化失败时降级为 nil，公开 API 会统一抛 DBError.openFailed
            debugPrint("DBManager init failed: \(error.localizedDescription)")
            dataBase = nil
        }
    }

    /// 创建数据库
    private func createDatabase() throws -> Database {
        debugPrint("🎷数据库路径:\(dataBasePath.absoluteString)")
        // WCDBSwift 的 Database(at:) 不会自己抛错，这里包一层 try 让上层感知失败。
        do {
            return try Database(at: dataBasePath)
        } catch {
            throw DBError.openFailed(path: dataBasePath.absoluteString)
        }
    }
    /// 创建数据表
    public func createTable<T: TableDecodable>(_ table: String, of type: T.Type) throws {
        do {
            try dataBase?.create(table: table, of: type)
        } catch {
            debugPrint("create table error \(error.localizedDescription)")
            throw DBError.createTableFailed(underlying: error)
        }
    }
    /// 删除数据表
    public func dropTable(_ table: String) throws {
        do {
            try dataBase?.drop(table: table)
        } catch {
            debugPrint("drop table error \(error)")
            throw DBError.dropTableFailed(underlying: error)
        }
    }
    /// 删除所有与该数据库相关的文件
    public func removeDbFile() throws {
        var caught: Error?
        try dataBase?.close(onClosed: {
            do {
                try dataBase?.removeFiles()
            } catch {
                caught = error
            }
        })
        if let caught = caught {
            debugPrint("not close db \(caught)")
            throw DBError.removeDbFileFailed(underlying: caught)
        }
    }
}