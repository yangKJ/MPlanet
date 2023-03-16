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
    lazy var bridge: Bridge = Bridge(window)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let _ = bridge.appDelegate.application?(application, didFinishLaunchingWithOptions: launchOptions)
        
        /// Check `Pods target -> Development Pods` for more details. 🎷🎷
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        bridge.appDelegate.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        bridge.appDelegate.applicationDidEnterBackground?(application)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        bridge.appDelegate.applicationDidBecomeActive?(application)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        bridge.appDelegate.applicationWillEnterForeground?(application)
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        bridge.appDelegate.application?(application, performActionFor: shortcutItem, completionHandler: completionHandler)
    }
}
