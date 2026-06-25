//
//  WMTabBarController.swift
//  AppMain
//
//  Created by Condy on 2024/5/10.
//

import Foundation
import FeatBox
import ESTabBarController_swift
import ProductLib

final class WMTabBarController: UITabBarController, Storyboardable/*ESTabBarController*/ {

    private var tabBarItems: [WMTabBarItem]

    init(tabBarItems: [WMTabBarItem]) {
        self.tabBarItems = tabBarItems
        super.init(nibName: nil, bundle: nil)
        self.delegate = self
    }

    required init?(coder: NSCoder) {
        self.tabBarItems = []
        super.init(coder: coder)
        StoryboardableFatal.notImplemented(coder: coder)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// 这段代码必须写在这里，写在viewDidLoad中，items还没有无法正确赋值
        for (index, _) in children.enumerated() {
            tabBar.items?[index].tag = index
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNotication()
        self.appearanceAdjustify()
        self.refreshViewControllers()
    }

    private func appearanceAdjustify() {
        tabBar.isTranslucent = false
        tabBar.tintColor = UIColor.fy.mainColor
        tabBar.barTintColor = UIColor.fy.background
        tabBar.backgroundColor = UIColor.fy.background
        tabBar.shadowImage = FeatBox.Placeholder.itemShadowImage
    }

    private func refreshViewControllers() {
        if self.viewControllers?.count ?? 0 > 0 {
            self.viewControllers?.removeAll()
        }
        // 收集有效的 ViewController 和对应的 WMTabBarItem（避免遍历中修改数组导致崩溃）
        var validViewControllers: [UIViewController] = []
        var validItems: [WMTabBarItem] = []
        for item in tabBarItems {
            if let vc = item.setupSubViewController() {
                validViewControllers.append(vc)
                validItems.append(item)
            }
        }
        self.viewControllers = validViewControllers
        self.tabBarItems = validItems
    }
    
    private func setupNotication() {
        /// 成功登陆，刷新`tabBar`个数
        /// 注意：必须 `.observe(on: MainScheduler.instance)`，
        /// 否则 RxSwift 通知会在投递时的原始线程（可能是后台线程）执行闭包，
        /// 进而触发 UIView/layer 属性在非主线程修改，导致崩溃：
        /// "Modifying properties of a view's layer off the main thread is not allowed"。
        Notify.Login.didLogin.rx
            .observe(on: MainScheduler.instance)
            .subscribe({ [weak self] _ in
                guard let hasPrivilegeBarItem = Session.shared.loggedUserDTO?.hasPrivilegeBarItem,
                      let item = WMTabBarItem.init(rawValue: hasPrivilegeBarItem) else {
                    return
                }
                // 防止重复加入（检查 wallet 是否已在 tabBarItems 中）
                if self?.tabBarItems.contains(item) ?? false {
                    return
                }
                if Session.shared.loginState == .logged, let vc = item.setupSubViewController() {
                    // 修复：removeFromParent 不为空时需要先移除，否则 addChild 时崩溃
                    vc.removeFromParent()
                    self?.tabBarItems.safeInsert(item, at: item.tag)
                    self?.viewControllers?.safeInsert(vc, at: item.tag)
                }
            }).disposed(by: rx.disposeBag)

        /// 退出登陆
        /// 同上，UI 操作必须回到主线程。
        Notify.Login.didLogout.rx
            .observe(on: MainScheduler.instance)
            .subscribe({ [weak self] _ in
                guard let `self` = self, Session.shared.loginState == .none else {
                    return
                }
                // 对比默认和现在已有TabBar
                var removeIndexs: [Int] = []
                let items = AppMainUtil.standardTabBarItems
                for (index, item) in self.tabBarItems.enumerated() where items.allSatisfy { $0 != item } {
                    removeIndexs.append(index)
                }
                self.tabBarItems.safeRemoveSpecifiedIndices(removeIndexs)
                self.viewControllers?.safeRemoveSpecifiedIndices(removeIndexs)
            }).disposed(by: rx.disposeBag)
    }
}

extension WMTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // 解决中途增加tabBar出现，会退出到根页面的问题
        if tabBarController.selectedViewController == viewController {
            return false
        }
        // P1 修复：点击需要登录的 Tab 时，拦截并触发登录流程
        guard let index = viewControllers?.firstIndex(of: viewController),
              index < tabBarItems.count else {
            return true
        }
        let item = tabBarItems[index]
        if item.requiresLogin && Session.shared.loginState != .logged {
            let auth = LoginAuthVerification()
            auth.authVerificationAction(
                authCompletion: nil,
                uiCompletion: { [weak self] _ in
                    self?.selectedIndex = index
                },
                canceled: nil
            )
            return false
        }
        return true
    }
}
