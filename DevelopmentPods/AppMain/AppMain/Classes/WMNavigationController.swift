//
//  WMNavigationController.swift
//  AppMain
//
//  Created by Condy on 2020/12/29.
//

import UIKit
import HBDNavigationBar
import Cabinets

class WMNavigationController: HBDNavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.ai.background
        self.interactivePopGestureRecognizer?.delegate = self
        self.interactivePopGestureRecognizer?.delaysTouchesBegan = false
        self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = .all
        self.modalPresentationStyle = .fullScreen //适配iOS13（默认是page）
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let top = self.topViewController {
            return top.preferredStatusBarStyle
        }
        return .default
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        // 避免在首页疯狂左滑导致的卡死
        // Avoid freezing caused by crazy left swiping on the homepage
        interactivePopGestureRecognizer?.isEnabled = (viewControllers.count > 0)
        viewController.hidesBottomBarWhenPushed = !(viewControllers.isEmpty)
        super.pushViewController(viewController, animated: animated)
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        viewControllers.last?.hidesBottomBarWhenPushed = (viewControllers.isEmpty)
        super.setViewControllers(viewControllers, animated: animated)
    }
    
    // 是否支持自动转屏
    // Whether to support automatic screen rotation
    override var shouldAutorotate: Bool {
        return topViewController?.shouldAutorotate ?? false
    }
    // 支持哪些屏幕方向
    // Which screen orientations are supported
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return topViewController?.supportedInterfaceOrientations ?? .portrait
    }
    // 默认的屏幕方向
    // default screen orientation
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
    // 是否隐藏状态栏
    // Whether to hide the status bar
    override var prefersStatusBarHidden: Bool {
        return topViewController?.prefersStatusBarHidden ?? false
    }
}

extension WMNavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.interactivePopGestureRecognizer &&
            (self.viewControllers.count < 2 || self.visibleViewController == self.viewControllers.first || self.shouldNotBegan()) {
            return false
        }
        return true
    }
    
    private func shouldNotBegan() -> Bool {
        return false
    }
}
