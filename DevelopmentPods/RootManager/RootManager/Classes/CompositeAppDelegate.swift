//
//  CompositeAppDelegate.swift
//  RootManager
//
//  Created by Condy on 2023/3/13.
//

import Foundation

public typealias AppDelegateType = UIResponder & UIApplicationDelegate

public final class CompositeAppDelegate: AppDelegateType {
    private let appDelegates: [AppDelegateType]
    
    init(appDelegates: [AppDelegateType]) {
        self.appDelegates = appDelegates
    }
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        appDelegates.forEach { _ = $0.application?(application, didFinishLaunchingWithOptions: launchOptions) }
        return true
    }
    
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        appDelegates.forEach { _ = $0.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken) }
    }
    
    public func applicationDidEnterBackground(_ application: UIApplication) {
        appDelegates.forEach { _ = $0.applicationDidEnterBackground?(application) }
    }
    
    public func applicationDidBecomeActive(_ application: UIApplication) {
        appDelegates.forEach { _ = $0.applicationDidBecomeActive?(application) }
    }
    
    public func applicationWillEnterForeground(_ application: UIApplication) {
        appDelegates.forEach { _ = $0.applicationWillEnterForeground?(application) }
    }
    
    public func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        appDelegates.forEach { _ = $0.application?(application, performActionFor: shortcutItem, completionHandler: completionHandler) }
    }
    
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        appDelegates.forEach { _ = $0.application?(app, open: url, options: options) }
        return true
    }
}
