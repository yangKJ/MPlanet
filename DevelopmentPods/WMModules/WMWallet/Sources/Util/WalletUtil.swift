//
//  WalletUtil.swift
//  WMWallet
//
//  Created by Condy on 2020/12/28.
//

import UIKit
import FeatBox

struct WalletUtil {
    static let moduleName = "WMWallet"
}

extension Res {
    
    static func image(_ named: String) -> UIImage {
        self.image(named, forResource: WalletUtil.moduleName)
    }
    
    static func text(_ string: String) -> String {
        self.text(string, forResource: WalletUtil.moduleName)
    }
}
