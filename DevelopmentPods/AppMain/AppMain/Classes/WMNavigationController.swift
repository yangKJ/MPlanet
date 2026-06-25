//
//  WMNavigationController.swift
//  AppMain
//
//  Created by Condy on 2020/12/29.
//

import UIKit
import HBDNavigationBar
import FeatBox

class WMNavigationController: HBDNavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.fy.background
        self.interactivePopGestureRecognizer?.delegate = self
        self.interactivePopGestureRecognizer?.delaysTouchesBegan = false
        self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = .all
        self.modalPresentationStyle = .fullScreen //适配iOS13（默认是page）
        // 美化：全局 HBD nav bar 标题字号 bold_18（与 Wallet/Discover/Chat 视觉统一）
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor.fy.title,
                .font: UIFont.fy.bold_18
            ]
            HBDNavigationBar.appearance().standardAppearance = appearance
            HBDNavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }

    /// 修复：HBD 默认画一个 ~44pt 的虚拟 nav bar（即使调了 setNavigationBarHidden 也不消失），
    /// 这里覆盖 viewControllers 写入逻辑，让每个 push 进来的子 VC 默认 hbd_barHidden = true，
    /// 自定义渐变顶栏（Discover/Learn/Topics）才不会被 HBD 顶栏"压"在最顶显示。
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        viewControllers.forEach { configureHBD(for: $0) }
        viewControllers.last?.hidesBottomBarWhenPushed = (viewControllers.isEmpty)
        super.setViewControllers(viewControllers, animated: animated)
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        // 避免在首页疯狂左滑导致的卡死
        // Avoid freezing caused by crazy left swiping on the homepage
        interactivePopGestureRecognizer?.isEnabled = (viewControllers.count > 0)
        viewController.hidesBottomBarWhenPushed = !(viewControllers.isEmpty)
        // 修复：HBD 虚拟顶栏默认占 ~44pt,显式 hbd_barHidden = true 让自定义渐变顶栏占满
        configureHBD(for: viewController)
        super.pushViewController(viewController, animated: animated)
    }

    /// 通过 KVC 给 HBD 的 ObjC 关联属性设值
    /// hbd_barHidden / hbd_barTintColor / hbd_barImage 都是 ObjC runtime 关联对象,
    /// Swift 子类直接调不到,必须用 setValue:forKey: 走 KVC
    private func configureHBD(for vc: UIViewController) {
        vc.setValue(true, forKey: "hbd_barHidden")
        // 同时把背景色设成主色绿,这样 HBD bar 即使画出来也是绿色,
        // 与下方自定义渐变顶栏融为一体
        vc.setValue(UIColor.fy.mainColor, forKey: "hbd_barTintColor")
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
        if gestureRecognizer == self.interactivePopGestureRecognizer,
           (self.viewControllers.count < 2 || self.visibleViewController == self.viewControllers.first || self.shouldNotBegan()) {
            return false
        }
        return true
    }
    
    private func shouldNotBegan() -> Bool {
        if UIViewController.fy.currentViewController() is BubblePopupViewController {
            return true
        }
        return false
    }
}
