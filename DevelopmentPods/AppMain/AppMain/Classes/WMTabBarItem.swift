//
//  WMTabBarItem.swift
//  AppMain
//
//  Created by Condy on 2021/1/17.
//

import Foundation
import Harbeth
import Mediator
import Rickenbacker

enum WMTabBarItem: Int {
    case dicover
    case wallet
    case mine
}

extension WMTabBarItem {
    
    private var title: String {
        switch self {
        case .dicover:
            return R.text("发现", forResource: AppMainUtil.moduleName)
        case .wallet:
            return R.text("钱包", forResource: AppMainUtil.moduleName)
        case .mine:
            return R.text("个人主页", forResource: AppMainUtil.moduleName)
        }
    }
    
    private var image: UIImage? {
        switch self {
        case .dicover:
            return R.image("tab_find", forResource: AppMainUtil.moduleName)
        case .wallet:
            return R.image("tab_book", forResource: AppMainUtil.moduleName)
        case .mine:
            return R.image("tab_mine", forResource: AppMainUtil.moduleName)
        }
    }
    
    private var selectImage: UIImage? {
        switch self {
        case .dicover:
            return R.image("tab_find_selected", forResource: AppMainUtil.moduleName)
        case .wallet:
            return R.image("tab_book_selected", forResource: AppMainUtil.moduleName)
        case .mine:
            return R.image("tab_mine_selected", forResource: AppMainUtil.moduleName)
        }
    }
    
    private var itemViewController: UIViewController? {
        switch self {
        case .dicover:
            return Mediator.Discover_viewController()
        case .wallet:
            return Mediator.Wallet_viewController()
        case .mine:
            return Mediator.Mine_viewController(userId: "Condy_21335932940")
        }
    }
    
    func childViewController() -> WMNavigationController? {
        guard let viewController = itemViewController else { return nil }
        let image = image?.withRenderingMode(.alwaysOriginal)
        let selectImage = selectImage?.withRenderingMode(.alwaysOriginal)
        let item = UITabBarItem(title: nil, image: image, selectedImage: selectImage)
        item.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: -5, right: 0)
        viewController.tabBarItem = item
        //viewController.title = title
        return WMNavigationController(rootViewController: viewController)
    }
}
