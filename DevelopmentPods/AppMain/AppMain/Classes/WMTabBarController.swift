//
//  WMTabBarController.swift
//  AppMain
//
//  Created by Condy on 2024/5/10.
//

import Foundation
import FeatBox
import ESTabBarController_swift

final class WMTabBarController: ESTabBarController {
    
    private var tabBarItems: [WMTabBarItem]
    
    init(tabBarItems: [WMTabBarItem]) {
        self.tabBarItems = tabBarItems
        super.init(nibName: nil, bundle: nil)
        self.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(didLogin), name: Notify.Login.didLogin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didLoginOut), name: Notify.Login.didLogout, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        self.appearanceAdjustify()
        self.constructViewControllers()
    }
    
    private func appearanceAdjustify() {
        tabBar.isTranslucent = false
        tabBar.tintColor = UIColor.fy.background
        tabBar.barTintColor = UIColor.fy.background
        tabBar.backgroundColor = UIColor.fy.background
        tabBar.shadowImage = FeatBox.Placeholder.itemShadowImage
    }
    
    private func constructViewControllers() {
        refreshViewControllers()
    }
    
    @objc private func refreshViewControllers() {
        if self.viewControllers?.count ?? 0 > 0 {
            self.viewControllers?.removeAll()
        }
        self.viewControllers = tabBarItems.enumerated().compactMap {
            if let vc = $1.setupSubViewController() {
                return vc
            } else {
                tabBarItems.remove(at: $0)
                return nil
            }
        }
    }
    
    @objc private func didLogin() {
        if Session.shared.loginState == .logged,
           let hasPrivilegeBarItem = Session.shared.loggedUserDTO?.hasPrivilegeBarItem,
           let item = WMTabBarItem(rawValue: hasPrivilegeBarItem),
           self.tabBarItems.allSatisfy({ $0 != item }), // 防止重复加入
           let vc = item.setupSubViewController() {
            self.tabBarItems.safeInsert(item, at: item.tag)
            self.viewControllers?.safeInsert(vc, at: item.tag)
        }
    }
    
    @objc private func didLoginOut() {
        guard Session.shared.loginState == .none else {
            return
        }
        // 对比默认和现在已有TabBar
        var removeIndexs: [Int] = []
        for (index, item) in self.tabBarItems.enumerated() {
            if AppMainUtil.standardTabBarItems.allSatisfy { $0 != item } {
                removeIndexs.append(index)
            }
        }
        self.tabBarItems.safeRemoveSpecifiedIndices(removeIndexs)
        self.viewControllers?.safeRemoveSpecifiedIndices(removeIndexs)
    }
}

extension WMTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // 解决中途增加tabBar出现，会退出到根页面的问题
        if tabBarController.selectedViewController == viewController {
            return false
        }
        return true
    }
}
