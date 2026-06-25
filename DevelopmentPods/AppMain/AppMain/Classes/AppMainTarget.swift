//
//  AppMainTarget.swift
//  AppMain
//
//  Created by Condy on 2024/5/10.
//

import Foundation
import FeatBox
import ESTabBarController_swift

/// 配置`Target`供外界组件调用
class AppMainTarget: NSObject {
    
    @objc public func gotoTabBarIndex(_ params: [String: Any]?) -> Bool {
        // 修复：原代码用 viewControllerType 反射判断 WMTabBarItem 的目标类型，
        // WMTabBarItem 重构后不再暴露 viewControllerType。改用 tag 直接定位。
        guard let gotoObject = params?["gotoObject"] as? String,
              let tabbarEnum = WMTabBarItem(rawValue: gotoObject),
              let tabBarController = UIApplication.shared.delegate?.window??.rootViewController as? WMTabBarController,
              tabbarEnum.tag < (tabBarController.viewControllers?.count ?? 0) else {
            return false
        }
        let index = tabbarEnum.tag

        if tabbarEnum.requiresLogin {
            let auth = LoginAuthVerification()
            auth.startDestinationAction(destinationActionWhenUICompletion: true, action: { _ in
                UIViewController.fy.popOrDismissToRootViewController(animated: true, selectedTabIndex: index, completion: nil)
            })
            return true
        }

        return false
    }
}
