//
//  AppMainTarget.swift
//  AppMain
//
//  Created by Condy on 2024/5/10.
//

import Foundation
import FeatBox

/// 配置`Target`供外界组件调用
class AppMainTarget: NSObject {
    
    @objc public func gotoTabBarIndex(_ params: [String: Any]?) -> Bool {
        guard let gotoObject = params?["gotoObject"] as? String,
              let tabbarEnum = WMTabBarItem(rawValue: gotoObject),
              let viewControllerType = tabbarEnum.viewControllerType,
              let tabBarVc = (UIApplication.shared.delegate as? BridgeAppDelegateable)?.bridgeRootViewController as? WMTabBarController,
              let viewControllers = tabBarVc.viewControllers as? [WMNavigationController],
              let index = viewControllers.firstIndex(where: {
                  $0.topViewController?.isMember(of: viewControllerType) ?? false
              }) else {
            return false
        }
        if tabBarVc.shouldHijackHandler?(tabBarVc, viewControllers[index], index) == false {
            // pop to root view controller.
            UIViewController.fy.popOrDismissToRootViewController(animated: false) {
                tabBarVc.selectedIndex = index
            }
            return true
        }
        return false
    }
}
