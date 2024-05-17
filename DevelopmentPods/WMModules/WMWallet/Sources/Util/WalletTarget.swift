//
//  WalletTarget.swift
//  WMWallet
//
//  Created by Condy on 2020/12/28.
//

import UIKit

class WalletTarget: NSObject {
    
    @objc public func getWalletViewControllerType() -> UIViewController.Type {
        return WalletViewController.self
    }
    
    /// 备注提示，这里必须加上`@objc`
    /// 否则会出现找不到该方法从而导致控制器为`nil`问题
    @objc func setupWalletViewController() -> UIViewController? {
        let vc = WalletViewController.init()
        return vc
    }
}
