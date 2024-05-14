//
//  AppMainUtil.swift
//  AppMain
//
//  Created by Condy on 2020/12/28.
//

import Foundation
import FeatBox

public struct AppMainUtil {
    
    internal static let moduleName = "AppMain"
    
    /// 标准主题用户默认TabBar
    public static var standardTabBarItems: [WMTabBarItem] = [.dicover, .mine]
    
    public static func rootViewController() -> UIViewController {
        Configs.initStandardConfigs() // 初始化配置
        return WMTabBarController(tabBarItems: standardTabBarItems)
    }
}
