//
//  Bridge.swift
//  RootManager
//
//  Created by Condy on 2023/3/13.
//

import Foundation

public typealias AppDelegateType = UIResponder & UIApplicationDelegate

public final class Bridge: AppDelegateType {
    
    private let appDelegates: [AppDelegateType]
    
    public init(_ window: UIWindow?) {
        self.appDelegates = [
            ConfigsAppDelegate.init(),
            RootAppDelegate.init(window: window),
            LauncherAppDelegate.init(window: window),
        ]
    }
    
    /// App启动完成
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        appDelegates.forEach { _ = $0.application?(application, didFinishLaunchingWithOptions: launchOptions) }
        return true
    }
    
    /// App成功注册远程通知后被调用，在接收到设备令牌后执行任何自定义代码
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        appDelegates.forEach { _ = $0.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken) }
    }
    
    /// App重新进入活动状态
    public func applicationDidBecomeActive(_ application: UIApplication) {
        appDelegates.forEach { _ = $0.applicationDidBecomeActive?(application) }
    }
    
    /// App即将失去活动状态，挂起时执行。当有电话进来或者锁屏时，应用程序便会挂起
    public func applicationWillResignActive(_ application: UIApplication) {
        appDelegates.forEach { _ = $0.applicationWillResignActive?(application) }
    }
    
    /// App进入后台
    public func applicationDidEnterBackground(_ application: UIApplication) {
        appDelegates.forEach { _ = $0.applicationDidEnterBackground?(application) }
    }
    
    /// App即将进入前台
    public func applicationWillEnterForeground(_ application: UIApplication) {
        appDelegates.forEach { _ = $0.applicationWillEnterForeground?(application) }
    }
    
    /// 通过 url scheme 唤起App
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var canHandel = false
        appDelegates.forEach {
            let can = $0.application?(app, open: url, options: options) ?? false
            if can {
                canHandel = true
            }
        }
        return canHandel
    }
    
    /// 通过通用链接唤起App
    public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        var canHandel = false
        appDelegates.forEach {
            let can = $0.application?(application, continue: userActivity, restorationHandler: restorationHandler) ?? false
            if can {
                canHandel = true
            }
        }
        return canHandel
    }
    
    public func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        var should = false
        appDelegates.forEach {
            let can = $0.application?(application, shouldAllowExtensionPointIdentifier: extensionPointIdentifier) ?? false
            if can {
                should = true
            }
        }
        return should
    }
    
    /// 当iOS决定在后台获取更新内容时调用，你可以在这里实现你的后台获取代码
    public func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        appDelegates.forEach { _ = $0.application?(application, performActionFor: shortcutItem, completionHandler: completionHandler) }
    }
}
