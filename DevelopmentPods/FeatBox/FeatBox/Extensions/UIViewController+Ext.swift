//
//  UIViewController+Ext.swift
//  ProductLib
//
//  Created by Condy on 2024/5/10.
//

import Foundation
import ProductLib
import ESTabBarController_swift

extension BoxWrapper where Base: UIViewController {
    
    public static func popOrDismissToRootViewController(animated: Bool, selectedTabIndex: Int = 0, completion: (() -> Void)?) {
        guard let currentViewController = self.currentViewController() else {
            completion?()
            return
        }
        self.popOrDismissToRootViewController(controller: currentViewController, selectedTabIndex: selectedTabIndex, animated: animated, completion: completion)
    }
    
    private static func popOrDismissToRootViewController(controller: UIViewController?, selectedTabIndex: Int, animated: Bool, completion: (() -> Void)?) {
        guard let controller = controller else {
            completion?()
            return
        }
        if controller.presentingViewController != nil {
            if animated {
                controller.dismiss(animated: animated, completion: {
                    self.popOrDismissToRootViewController(controller: self.currentViewController(), selectedTabIndex: selectedTabIndex, animated: animated, completion: completion)
                })
            } else {
                // fix a bug: is dismissing, completion not invoked
                controller.dismiss(animated: animated, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.popOrDismissToRootViewController(controller: self.currentViewController(), selectedTabIndex: selectedTabIndex, animated: animated, completion: completion)
                }
            }
        } else if let navigationController = controller.navigationController, navigationController.viewControllers.count > 1 {
            navigationController.fy.popToRootViewController(animated: animated, completion: {
                self.popOrDismissToRootViewController(controller: self.currentViewController(), selectedTabIndex: selectedTabIndex, animated: animated, completion: completion)
            })
        } else if let navigationController = controller.navigationController,
                  navigationController.viewControllers.count == 1,
                  let tabbarController = controller.tabBarController,
                  let viewControllers = tabbarController.viewControllers,
                  viewControllers.count > selectedTabIndex {
            if let tabBarVc = tabbarController as? ESTabBarController {
                if tabBarVc.shouldHijackHandler?(tabBarVc, viewControllers[selectedTabIndex], selectedTabIndex) == false {
                    tabBarVc.selectedIndex = selectedTabIndex
                }
            } else {
                tabbarController.selectedIndex = selectedTabIndex
            }
            completion?()
        } else {
            completion?()
        }
    }
}
