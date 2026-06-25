//
//  ExUIViewController.swift
//  FeatBox
//
//  Created by Condy on 2020/11/23.
//

import UIKit

extension BoxWrapper where Base: UIViewController {

    /// 内部辅助方法：获取当前 keyWindow 的 rootViewController
    /// - Note: 修复：iOS 13+ 之后 UIApplication.shared.delegate?.window 在 SceneDelegate
    ///   架构下可能为 nil（AppDelegate.window 在 Scene 启动后不会被自动设置）。
    ///   改为先尝试 UIWindowScene.windows，再 fallback 到 AppDelegate.window。
    private static func fetchRootViewController() -> UIViewController? {
        // iOS 13+：通过 Scene 拿 key window
        if #available(iOS 13.0, *) {
            for scene in UIApplication.shared.connectedScenes {
                if let windowScene = scene as? UIWindowScene,
                   windowScene.activationState == .foregroundActive,
                   let keyWindow = windowScene.windows.first(where: \.isKeyWindow) {
                    return keyWindow.rootViewController
                }
            }
        }
        // fallback：AppDelegate.window（兼容老 AppDelegate-only 架构）
        if let delegateWindow = UIApplication.shared.delegate?.window,
           let delegateWindowValue = delegateWindow {
            return delegateWindowValue.rootViewController
        }
        // 最后一搏：iOS 13 以下 keyWindow
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first(where: \.isKeyWindow)?
                .rootViewController
        } else {
            return UIApplication.shared.keyWindow?.rootViewController
        }
    }

    public static func currentViewController() -> UIViewController? {
        // 修复：使用 fetchRootViewController 替代 UIApplication.shared.delegate?.window??.rootViewController
        guard let rootViewController = fetchRootViewController() else {
            return nil
        }
        return getTopViewController(controller: rootViewController)
    }

    public static func getTopViewController(controller: UIViewController) -> UIViewController {
        if let presentedViewController = controller.presentedViewController {
            return self.getTopViewController(controller: presentedViewController)
        } else if let navigationController = controller as? UINavigationController {
            if let topViewController = navigationController.topViewController {
                return self.getTopViewController(controller: topViewController)
            }
            return navigationController
        } else if let tabbarController = controller as? UITabBarController {
            if let selectedViewController = tabbarController.selectedViewController {
                return self.getTopViewController(controller: selectedViewController)
            }
            return tabbarController
        } else {
            return controller
        }
    }

    public var fullNavbarHeight: CGFloat {
        return navbarHeight + statusBarHeight
    }

    public var navbarHeight: CGFloat {
        return base.navigationController?.navigationBar.frame.size.height ?? 44
    }

    public var statusBarHeight: CGFloat {
        var statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        if #available(iOS 11.0, *) {
            // 修复：使用 fetchRootViewController 找到的 keyWindow，
            // 替代 UIApplication.shared.delegate?.window??.safeAreaInsets.top
            let safeTop = Self.fetchRootViewController()?.view.window?.safeAreaInsets.top ?? 0
            statusBarHeight = max(statusBarHeight, safeTop)
        }
        return statusBarHeight - extendedStatusBarDifference
    }

    // Extended status call changes the bounds of the presented view
    public var extendedStatusBarDifference: CGFloat {
        // 修复：使用 fetchRootViewController 拿到 keyWindow 来计算
        let windowHeight = Self.fetchRootViewController()?.view.window?.frame.size.height ?? UIScreen.main.bounds.height
        return Swift.abs(base.view.bounds.height - windowHeight)
    }
    
    public var tabBarOffset: CGFloat {
        // Only account for the tab bar if a tab bar controller is present and the bar is not translucent
        if let tabBarController = base.tabBarController,
           !(base.navigationController?.topViewController?.hidesBottomBarWhenPushed ?? false) {
            return tabBarController.tabBar.isTranslucent ? 0 : tabBarController.tabBar.frame.height
        }
        return 0
    }
    
    public func add(childViewController child: UIViewController, frame: CGRect = UIScreen.main.bounds) {
        guard !base.children.contains(child) else { return }
        child.view.frame = frame
        base.view.addSubview(child.view)
        base.addChild(child)
        child.didMove(toParent: base)
    }
    
    public func remove(childViewController child: UIViewController) {
        guard base.children.contains(child) else { return }
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
    
    @discardableResult
    public func popToViewController(advancedBy: Int, animated: Bool = true) -> Bool {
        assert(advancedBy < 0, "non positive")
        guard let navigationVc = base.navigationController else {
            print("ProductLib warning: no navigation controller exists")
            return false
        }
        guard advancedBy < navigationVc.children.count else {
            print("ProductLib warning: iligal advancedBy value")
            return false
        }
        let index = navigationVc.children.index(of: base)!
        let dstVc = navigationVc.children[index + advancedBy]
        navigationVc.popToViewController(dstVc, animated: animated)
        return true
    }
    
    @discardableResult
    public func popToViewController(metaType: UIViewController.Type, animated: Bool = true) -> Bool {
        guard let navigationVc = base.navigationController else {
            print("ProductLib warning: no navigation controller exists")
            return false
        }
        guard let dstVc = navigationVc.children.last(where: { $0.isKind(of: metaType) }) else {
            print("ProductLib warning: no view controller(\(metaType)) exists in its navigation controller's stack")
            return false
        }
        navigationVc.popToViewController(dstVc, animated: animated)
        return true
    }
}
