//
//  AppMainUtil.swift
//  AppMain
//
//  Created by Condy on 2020/12/28.
//

import Foundation

public struct AppMainUtil {
    
    internal static let moduleName = "AppMain"
    
    public static func rootViewController() -> UIViewController {
        let items: [WMTabBarItem] = [.dicover, .wallet, .mine]
        return WMTabBarController(tabBarItems: items)
    }
}
