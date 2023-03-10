//
//  WalletTokenData.swift
//  Database
//
//  Created by Condy on 2020/12/7.
//

import UIKit
import WCDBSwift

/// 字段详解见文档：`Tables/WalletToken.numbers

public struct WalletTokenData: TableCodable {
    // 表名
    public static let Wallet_Token_table = "Wallet_token_table"
    
    public var ID: Int?
    public var chainName: String?
    public var icon: String?
    public var amount: String?
    public var unit: String?
    public var selected: Bool?
    public var chainIcon: String?
    public var chain: String?
    public var chainID: Int?
    public var walletDetailsID: Int?
    
    public init() { }
    
    public enum CodingKeys: String, CodingTableKey {
        public typealias Root = WalletTokenData
        public static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
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
        
        public static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                .ID: ColumnConstraintBinding(isPrimary: true, isAutoIncrement: false),
            ]
        }
    }
}

public extension WalletTokenData {
    
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
