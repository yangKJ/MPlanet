//
//  WalletApplicationData.swift
//  Database
//
//  Created by Condy on 2020/12/7.
//

import UIKit
import WCDBSwift

/// 字段详解见文档：`Tables/WalletApplication.numbers

public struct WalletApplicationData: TableCodable {
    // 表名
    public static let Wallet_Application_table = "Wallet_application_table"
    
    public var ID: Int?
    public var title: String?
    public var icon: String?
    public var sort: Int?
    public var selected: Bool?
    
    public init() { }
    
    public enum CodingKeys: String, CodingTableKey {
        public typealias Root = WalletApplicationData
        public static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case ID
        case title
        case icon
        case sort
        case selected
        
        public static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                .ID: ColumnConstraintBinding(isPrimary: true, isAutoIncrement: false),
            ]
        }
    }
}

public extension WalletApplicationData {
    
    static func query(walletID: Int) -> [WalletApplicationData] {
        // TODO: 测试数据
        var array: [WalletApplicationData] = []
        for index in 0...2 {
            var app = WalletApplicationData.init()
            app.ID = index
            app.title = "标题" + "\(index)"
            array.append(app)
        }
        return array
    }
}
