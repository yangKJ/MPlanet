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
    
    /// 标准主题用户默认 TabBar
    public static var standardTabBarItems: [WMTabBarItem] = [.discover, .learn, .topics, .mine]
    
    public static func rootViewController() -> UIViewController {
        WMTabBarController(tabBarItems: standardTabBarItems)
    }
}
