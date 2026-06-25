//
//  DBError.swift
//  YoDatabase
//

import Foundation

/// 数据库操作统一错误类型。公开 API 改为 throws 后，
/// 业务层通过 catch 转 `errorSubject` 走统一错误流。
public enum DBError: Error, CustomStringConvertible {
    /// 打开数据库失败
    case openFailed(path: String)
    /// 创建数据表失败
    case createTableFailed(underlying: Error)
    /// 删除数据表失败
    case dropTableFailed(underlying: Error)
    /// 删除数据库文件失败
    case removeDbFileFailed(underlying: Error)
    /// 查询失败
    case queryFailed(underlying: Error)
    /// 插入失败
    case insertFailed(underlying: Error)
    /// 批量插入失败
    case insertBatchFailed(underlying: Error)
    /// 更新失败
    case updateFailed(underlying: Error)
    /// 删除失败
    case deleteFailed(underlying: Error)
    /// 缺少必要的 where 条件（安全护栏）
    case whereConditionRequired(operation: String)
    /// 没有找到对应的表
    case noTableFound(name: String)

    public var description: String {
        switch self {
        case .openFailed(let path):
            return "DBManager open failed: \(path)"
        case .createTableFailed(let error):
            return "DBManager createTable failed: \(error.localizedDescription)"
        case .dropTableFailed(let error):
            return "DBManager dropTable failed: \(error.localizedDescription)"
        case .removeDbFileFailed(let error):
            return "DBManager removeDbFile failed: \(error.localizedDescription)"
        case .queryFailed(let error):
            return "DBManager query failed: \(error.localizedDescription)"
        case .insertFailed(let error):
            return "DBManager insert failed: \(error.localizedDescription)"
        case .insertBatchFailed(let error):
            return "DBManager insertBatch failed: \(error.localizedDescription)"
        case .updateFailed(let error):
            return "DBManager update failed: \(error.localizedDescription)"
        case .deleteFailed(let error):
            return "DBManager delete failed: \(error.localizedDescription)"
        case .whereConditionRequired(let operation):
            return "DBManager.\(operation) safety guard: where condition is nil, refusing full-table operation."
        case .noTableFound(let name):
            return "DBManager noTableFound: \(name)"
        }
    }

    public var localizedDescription: String {
        description
    }
}