//
//  WalletAPI.swift
//  WMWallet
//
//  Created by Condy on 2020/12/28.
//

import FeatBox

enum WalletAPI {
    /// 应用程序列表
    case applicationList(String)
    /// 代币列表
    case tokenList(String)
}
