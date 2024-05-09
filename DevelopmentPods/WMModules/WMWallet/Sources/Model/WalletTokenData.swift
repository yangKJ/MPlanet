//
//  WalletTokenData.swift
//  Database
//
//  Created by Condy on 2020/12/7.
//

import UIKit
import Database
import WCDBSwift
import HandyJSON

/// 字段详解见文档：`Database/Tables/WalletToken.numbers

struct WalletTokenData: HandyJSON {
    var ID: Int?
    var chainName: String?
    var icon: String?
    var amount: String?
    var unit: String?
    var selected: Bool?
    var chainIcon: String?
    var chain: String?
    var chainID: Int?
    var walletDetailsID: Int?
}

extension WalletTokenData: TableCodable {
    // 表名
    static let Wallet_Token_table = "Wallet_token_table"
    
    enum CodingKeys: String, CodingTableKey {
        case ID
        case chainName
        case icon
        case amount
        case unit
        case chainIcon
        case selected
        case chain
        case chainID
        case walletDetailsID
        
        typealias Root = WalletTokenData
        static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(ID, isPrimary: true)
        }
    }
}

extension WalletTokenData {
    
    static func query(walletID: Int) -> [WalletTokenData] {
        // TODO: 测试数据
        var array: [WalletTokenData] = []
        for index in 0..<20 {
            var app = WalletTokenData.init()
            app.ID = index
            app.chainName = "标题" + "\(index+1)"
            app.amount = "\(arc4random())" + "." + "\(arc4random()/1000000)"
            app.unit = "BTC"
            array.append(app)
        }
        return array
    }
}
