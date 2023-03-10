//
//  WalletData.swift
//  Database
//
//  Created by Condy on 2020/12/7.
//

import UIKit
import WCDBSwift

/// 字段详解见文档：`Tables/Wallet.numbers

public struct WalletData: TableCodable {
    // 表名
    public static let Wallet_table = "Wallet_table"
    
    public var ID: Int?
    public var walletName: String?
    public var accountName: String?
    public var asset: String?
    public var selected: Bool?
    public var chainIcon: String?
    public var chain: String?
    public var chainID: Int?
    public var walletDetailsID: Int?
    
    public init() { }
    
    public enum CodingKeys: String, CodingTableKey {
        public typealias Root = WalletData
        public static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case ID
        case walletName
        case accountName
        case asset
        case chainIcon
        case selected
        case chain
        case chainID
        case walletDetailsID
        
        public static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                .ID: ColumnConstraintBinding(isPrimary: true, isAutoIncrement: true),
            ]
        }
    }
}

public extension WalletData {
    
    /// 插入或更新数据
    static func insertOrUpdate(_ object: WalletData) {
        let obj: WalletData? = DBManager.shared.queryOne(fromTable: WalletData.Wallet_table,
                                                         where: WalletData.Properties.ID == object.ID!)
        if var obj = obj {
            obj.walletName = (object.walletName != nil) ? object.walletName : obj.walletName
            obj.accountName = (object.accountName != nil) ? object.accountName : obj.accountName
            DBManager.shared.update(table: WalletData.Wallet_table,
                                    with: obj,
                                    where: WalletData.Properties.ID == object.ID!)
        } else {
            DBManager.shared.insert(intoTable: WalletData.Wallet_table, objects: [object])
        }
    }
    
    static func querySelectedWallet() -> WalletData? {
        // TODO: 测试数据
        var wallet = WalletData.init()
        wallet.ID = 1
        wallet.selected = true
        wallet.asset = "1245"
        return wallet
        return DBManager.shared.queryOne(fromTable: WalletData.Wallet_table,
                                         where: WalletData.Properties.selected == true)
    }
}
