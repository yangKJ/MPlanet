//
//  WalletApplicationData.swift
//  Database
//
//  Created by Condy on 2020/12/7.
//

import UIKit
import Database
import WCDBSwift
import HandyJSON

/// 字段详解见文档：`Database/Tables/WalletApplication.numbers

struct WalletApplicationData: HandyJSON {
    var ID: Int?
    var title: String?
    var icon: String?
    var sort: Int?
    var selected: Bool?
}

extension WalletApplicationData: TableCodable {
    // 表名
    static let Wallet_Application_table = "Wallet_application_table"
    
    enum CodingKeys: String, CodingTableKey {
        case ID
        case title
        case icon
        case sort
        case selected
        
        typealias Root = WalletApplicationData
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                .ID: ColumnConstraintBinding(isPrimary: true, isAutoIncrement: false),
            ]
        }
    }
}

extension WalletApplicationData {
    
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
