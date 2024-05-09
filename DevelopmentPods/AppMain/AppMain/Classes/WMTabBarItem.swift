//
//  WMTabBarItem.swift
//  AppMain
//
//  Created by Condy on 2021/1/17.
//

import Foundation
import Mediator
import RAMAnimatedTabBarController
import FeatBox

enum WMTabBarItem: Int {
    case dicover
    case wallet
    case mine
}

extension WMTabBarItem {
    
    private var title: String {
        switch self {
        case .dicover:
            return Res.text("发现", forResource: AppMainUtil.moduleName)
        case .wallet:
            return Res.text("钱包", forResource: AppMainUtil.moduleName)
        case .mine:
            return Res.text("个人主页", forResource: AppMainUtil.moduleName)
        }
    }
    
    private var image: UIImage? {
        switch self {
        case .dicover:
            return Res.image("tab_find", forResource: AppMainUtil.moduleName)
        case .wallet:
            return Res.image("tab_book", forResource: AppMainUtil.moduleName)
        case .mine:
            return Res.image("tab_mine", forResource: AppMainUtil.moduleName)
        }
    }
    
    private var selectImage: UIImage? {
        switch self {
        case .dicover:
            return Res.image("tab_find_selected", forResource: AppMainUtil.moduleName)
        case .wallet:
            return Res.image("tab_book_selected", forResource: AppMainUtil.moduleName)
        case .mine:
            return Res.image("tab_mine_selected", forResource: AppMainUtil.moduleName)
        }
    }
    
    private var animation: RAMItemAnimation {
        let image = image?.withRenderingMode(.alwaysOriginal)
        let selectImage = selectImage?.withRenderingMode(.alwaysOriginal)
        switch self {
        case .dicover:
            let animation = WMBounceAnimation.init()
            animation.iconImage = image
            animation.iconSelectedImage = selectImage
            animation.textSelectedColor = UIColor.fy.mainColor
            return animation
        case .wallet:
            let animation = WMBounceAnimation.init()
            animation.iconImage = image
            animation.iconSelectedImage = selectImage
            animation.textSelectedColor = UIColor.fy.mainColor
            return animation
        case .mine:
            let animation = WMBounceAnimation.init()
            animation.iconImage = image
            animation.iconSelectedImage = selectImage
            animation.textSelectedColor = UIColor.fy.mainColor
            return animation
        }
    }
    
    private var itemViewController: UIViewController? {
        switch self {
        case .dicover:
            return Mediator.Discover_viewController()
        case .wallet:
            return Mediator.Wallet_viewController()
        case .mine:
            return Mediator.Mine_viewController(userId: "yangKJ")
        }
    }
    
    private func setupViewController(_ vc: UIViewController) {
        let item = RAMAnimatedTabBarItem(title: title, image: image, tag: rawValue)
        item.textColor = UIColor.clear//UIColor.fy.gray
        item.animation = animation
        item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -5, right: 0)
        vc.title = title
        vc.tabBarItem = item
    }
    
    func childViewController() -> WMNavigationController? {
        guard let viewController = itemViewController else {
            return nil
        }
        setupViewController(viewController)
        return WMNavigationController(rootViewController: viewController)
    }
}
