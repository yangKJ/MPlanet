//
//  WMTabBarController.swift
//  AppMain
//
//  Created by Condy on 2020/12/28.
//

import UIKit
import FeatBox
import RAMAnimatedTabBarController

final class WMTabBarController: RAMAnimatedTabBarController {
    
    var tabBarItems: [WMTabBarItem] = []
    
    init(tabBarItems: [WMTabBarItem]) {
        self.tabBarItems = tabBarItems
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return selectedViewController
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
        self.setupChildViewController()
    }
    
    private func appearanceAdjustify() {
        tabBar.isTranslucent = false
        tabBar.tintColor = UIColor.fy.background
        tabBar.barTintColor = UIColor.fy.background
        tabBar.backgroundColor = UIColor.fy.background
        tabBar.shadowImage = FeatBox.Placeholder.itemShadowImage
        //tabBar.backgroundImage = UIColor.fy.background.mt.colorImage()
    }
    
    private func setupChildViewController() {
        // 祛除空数据
        let controllers = tabBarItems.compactMap { $0.childViewController() }
        self.setViewControllers(controllers, animated: false)
    }
}
