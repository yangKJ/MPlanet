//
//  WMTabBarItem.swift
//  AppMain
//
//  Created by Condy on 2021/1/17.
//

import Foundation
import Mediator
import FeatBox
import ESTabBarController_swift

public enum WMTabBarItem: String, Equatable {
    case dicover = "TAB_BAR_DICOVER"
    case wallet = "TAB_BAR_WALLET"
    case mine = "TAB_BAR_MINE"
}

extension WMTabBarItem {
    
    var tag: Int {
        switch self {
        case .dicover:
            return 0
        case .wallet:
            return 1
        case .mine:
            return 2
        }
    }
    
    var title: String {
        switch self {
        case .dicover:
            return Res.text("发现", forResource: AppMainUtil.moduleName)
        case .wallet:
            return Res.text("钱包", forResource: AppMainUtil.moduleName)
        case .mine:
            return Res.text("个人主页", forResource: AppMainUtil.moduleName)
        }
    }
    
    var image: UIImage? {
        switch self {
        case .dicover:
            return Res.image("tab_find", forResource: AppMainUtil.moduleName)
        case .wallet:
            return Res.image("tab_book", forResource: AppMainUtil.moduleName)
        case .mine:
            return Res.image("tab_mine", forResource: AppMainUtil.moduleName)
        }
    }
    
    var selectImage: UIImage? {
        switch self {
        case .dicover:
            return Res.image("tab_find_selected", forResource: AppMainUtil.moduleName)
        case .wallet:
            return Res.image("tab_book_selected", forResource: AppMainUtil.moduleName)
        case .mine:
            return Res.image("tab_mine_selected", forResource: AppMainUtil.moduleName)
        }
    }
    
    var viewControllerType: UIViewController.Type? {
        switch self {
        case .dicover:
            return Mediator.discoverViewControllerType()
        case .wallet:
            return Mediator.walletViewControllerType()
        case .mine:
            return Mediator.mineViewControllerType()
        }
    }
    
    var itemViewController: UIViewController? {
        switch self {
        case .dicover:
            return Mediator.Discover_viewController()
        case .wallet:
            return Mediator.Wallet_viewController()
        case .mine:
            return Mediator.Mine_viewController(userId: "yangKJ")
        }
    }
    
    var itemContentView: ESTabBarItemContentView {
        var contentView: ESTabBarItemContentView!
        switch self {
        case .dicover:
            contentView = WMTabBarItemContentView()
        case .wallet:
            contentView = WMTabBarItemContentView()
        case .mine:
            contentView = WMTabBarItemContentView()
        }
        contentView.textColor = UIColor.fy.itemSubTitle
        contentView.highlightTextColor = UIColor.fy.mainColor
        contentView.titleLabel.font = UIFont.fy.system_13
        contentView.iconColor = UIColor.fy.itemSubTitle
        contentView.highlightIconColor = UIColor.fy.mainColor
        contentView.insets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        return contentView
    }
    
    func setupSubViewController() -> WMNavigationController? {
        guard let viewController = itemViewController else {
            return nil
        }
        let item = ESTabBarItem(itemContentView, title: title, image: image, selectedImage: selectImage, tag: tag)
        //viewController.title = title
        viewController.tabBarItem = item
        viewController.hidesBottomBarWhenPushed = false
        return WMNavigationController(rootViewController: viewController)
    }
}
