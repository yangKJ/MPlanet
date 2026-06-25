//
//  AppDelegate.swift
//  MainProject
//
//  Created by Condy on 2020/12/27.
//  Copyright (c) 2024 yangKJ. All rights reserved.
//

import UIKit
import RootManager
import FeatBox
import SDWebImage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, BridgeAppDelegateable {

    var bridgeUIWindow: UIWindow? {
        window
    }

    var bridgeRootViewController: UIViewController? {
        window?.rootViewController
    }

    var window: UIWindow?
    lazy var bridge: Bridge = Bridge.init(window)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        let _ = bridge.application(application, didFinishLaunchingWithOptions: launchOptions)

        // 性能修复：配置 SDWebImage 内存/磁盘缓存上限，防止 OOM
        // 内存：最多 100 张图 + 200MB；磁盘：最多 500MB，1 周过期
        // 注意：SDImageCacheConfig 没有 maxDiskCount 属性，靠 maxDiskSize 控制
        let cache = SDImageCache.shared
        cache.config.maxMemoryCount = 100
        cache.config.maxMemoryCost = 200 * 1024 * 1024  // 200 MB
        cache.config.maxDiskSize = 500 * 1024 * 1024    // 500 MB
        cache.config.shouldCacheImagesInMemory = true
        cache.config.diskCacheExpireType = .accessDate
        cache.config.maxDiskAge = 60 * 60 * 24 * 7     // 7 天

        /// Check `Pods target -> Development Pods` for more details. 🎷🎷

        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        bridge.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        bridge.applicationDidBecomeActive(application)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        bridge.applicationWillResignActive(application)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        bridge.applicationDidEnterBackground(application)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        bridge.applicationWillEnterForeground(application)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        bridge.application(app, open: url, options: options)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        bridge.application(application, continue: userActivity, restorationHandler: restorationHandler)
    }
    
    func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        bridge.application(application, shouldAllowExtensionPointIdentifier: extensionPointIdentifier)
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        bridge.application(application, performActionFor: shortcutItem, completionHandler: completionHandler)
    }
}
