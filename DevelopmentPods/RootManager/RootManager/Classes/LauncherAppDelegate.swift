//
//  LauncherAppDelegate.swift
//  RootManager
//
//  Created by Condy on 2024/5/20.
//

import Foundation
import FeatBox

/// 启动页广告
class LauncherAppDelegate: AppDelegateType {

    private static let version = "1"
    private static let imageNames: [String] = []

    weak var keyWindow: UIWindow?

    init(window: UIWindow?) {
        self.keyWindow = window
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 死代码清理：原 setupLauncher() 构建的 items 数组无下游使用，
        // LauncherSubItem / LauncherScrollView 已删除，imageNames 当前为空，
        // 此处仅保留入口供后续接入真实启动页广告。
        _ = Self.version
        _ = Self.imageNames
        return true
    }
}
