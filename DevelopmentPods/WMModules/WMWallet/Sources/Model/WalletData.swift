//
//  WalletData.swift
//  Database
//
//  Created by Condy on 2020/12/7.
//

import UIKit
import Database
import WCDBSwift
import HandyJSON

/// 字段详解见文档：`Database/Tables/Wallet.numbers

struct WalletData: HandyJSON {
    var ID: Int?
    var walletName: String?
    var accountName: String?
    var asset: String?
    var selected: Bool?
    var chainIcon: String?
    var chain: String?
    var chainID: Int?
    var walletDetailsID: Int?
}

extension WalletData: TableCodable {
    // 表名
    static let Wallet_table = "Wallet_table"
    
    enum CodingKeys: String, CodingTableKey {
        case ID
        case walletName
        case accountName
        case asset
        case chainIcon
        case selected
        case chain
        case chainID
        case walletDetailsID
        
        typealias Root = WalletData
        static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(ID, isPrimary: true, isAutoIncrement: true)
            //BindColumnConstraint(walletName, isNotNull: true, defaultTo: "defaultDescription")
        }
    }
}

extension WalletData {
    
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
