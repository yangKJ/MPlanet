//
//  RootManager.swift
//  RootManager
//
//  Created by Condy on 2020/12/29.
//

import UIKit
import AppMain

public struct RootManager {

    weak var window: UIWindow?
    
    public init(_ window: UIWindow?) {
        if let window = window {
            window.backgroundColor = UIColor.white
        }
        self.window = window
    }
    
    public func setupRootViewController() -> UIViewController {
        let vc = AppMain.AppMainUtil.rootViewController()
        return vc
    }
}
