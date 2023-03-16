//
//  WalletUtil.swift
//  WMWallet
//
//  Created by Condy on 2020/12/28.
//

import UIKit
import FeatBox

struct WalletUtil {
    internal static let moduleName = "WMWallet"
}

extension Rickenbacker.R {
    
    internal static func image(_ named: String) -> UIImage {
        self.image(named, forResource: WalletUtil.moduleName)
    }
    
    internal static func text(_ string: String) -> String {
        self.text(string, forResource: WalletUtil.moduleName)
    }
}
