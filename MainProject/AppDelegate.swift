//
//  AppDelegate.swift
//  MainProject
//
//  Created by Condy on 2020/12/27.
//  Copyright (c) 2020 Condy. All rights reserved.
//

import UIKit
import RootManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.setupRootViewController()
        
        return true
    }
}

extension AppDelegate {
    
    func setupRootViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let root = RootManager.init(window)
        window?.rootViewController = root.setupRootViewController()
        
        window?.makeKeyAndVisible()
    }
}
