//
//  AppDelegate.swift
//  WMMine_Example
//
//  Created by Condy on 2023/03/17.
//  Copyright (c) 2023 Condy. All rights reserved.
//

import UIKit
import HBDNavigationBar
import Rickenbacker

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if let vc = Mediator.performTarget("MineTarget",
                                           action: "setupMineViewController:",
                                           module: "WMMine",
                                           params: ["userId": "1234"]) as? UIViewController {
            vc.title = "我的单元测试"
            let nav = HBDNavigationController.init(rootViewController: vc)
            window?.rootViewController = nav
            window?.makeKeyAndVisible()
        }
        
        return true
    }
}

