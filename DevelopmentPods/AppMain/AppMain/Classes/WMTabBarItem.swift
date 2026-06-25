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
    case discover = "TAB_BAR_DISCOVER"
    case learn = "TAB_BAR_LEARN"
    case topics = "TAB_BAR_TOPICS"
    case mine = "TAB_BAR_MINE"
    case wallet = "TAB_BAR_WALLET"
}

extension WMTabBarItem {

    var tag: Int {
        switch self {
        case .discover: return 0
        case .learn: return 1
        case .topics: return 2
        case .mine: return 3
        case .wallet: return 4
        }
    }

    var requiresLogin: Bool {
        switch self {
        case .discover: return false
        case .learn: return true
        case .topics: return false
        case .mine: return false
        case .wallet: return false
        }
    }

    /// Tab 标题
    var title: String {
        switch self {
        case .discover:
            return Res.text("发现", forResource: AppMainUtil.moduleName)
        case .learn:
            return Res.text("学习", forResource: AppMainUtil.moduleName)
        case .topics:
            return Res.text("主题", forResource: AppMainUtil.moduleName)
        case .mine:
            return Res.text("我的", forResource: AppMainUtil.moduleName)
        case .wallet:
            return Res.text("钱包", forResource: AppMainUtil.moduleName)
        }
    }

    /// Tab 未选中图标
    var image: UIImage? {
        let symbol: String
        switch self {
        case .discover: symbol = "safari"
        case .learn: symbol = "book"
        case .topics: symbol = "text.bubble"
        case .mine: symbol = "person"
        case .wallet: symbol = "creditcard"
        }
        let image = UIImage(systemName: symbol)
        // 美化：未选 20 regular → 22 regular，匹配选中态的尺寸对比
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
        return image?.withConfiguration(config)
    }

    /// Tab 选中图标（绿色 tint）
    var selectImage: UIImage? {
        let symbol: String
        switch self {
        case .discover: symbol = "safari.fill"
        case .learn: symbol = "book.fill"
        case .topics: symbol = "text.bubble.fill"
        case .mine: symbol = "person.fill"
        case .wallet: symbol = "creditcard.fill"
        }
        let image = UIImage(systemName: symbol)
        // 美化：选中 20 semibold → 22 semibold，视觉重量与未选态区分
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold)
        return image?.withTintColor(UIColor.fy.mainColor, renderingMode: .alwaysOriginal)
            .withConfiguration(config)
    }

    /// 通过 Mediator 反射获取 Tab 对应的 ViewController 实例
    /// 不依赖 MediatorExt 扩展方法，直接用 performTarget 字符串调用
    func makeViewController() -> UIViewController? {
        // performTarget(_ class:, action:, module:) 的第一个参数是 Target 类名（如 "DiscoverTarget"），
        // module 参数才是模块名（如 "WMDiscover"）。
        let (className, module, action): (String, String, String) = {
            switch self {
            case .discover: return ("DiscoverTarget", "WMDiscover", "Action_viewController:")
            case .learn: return ("LearnTarget", "WMLearn", "Action_viewController:")
            case .topics: return ("TopicsTarget", "WMTopics", "Action_viewController:")
            case .mine: return ("MineTarget", "WMMine", "Action_viewController:")
            case .wallet: return ("WalletTarget", "WMWallet", "Action_viewController:")
            }
        }()
        return Mediator.performTarget(className, action: action, module: module, params: nil) as? UIViewController
    }

    var itemContentView: ESTabBarItemContentView {
        let contentView = WMTabBarItemContentView()
        contentView.textColor = UIColor.fy.itemSubTitle
        contentView.highlightTextColor = UIColor.fy.mainColor
        // 美化：title 字号 13 → 12，更精致
        contentView.titleLabel.font = UIFont.fy.system_12
        contentView.iconColor = UIColor.fy.itemSubTitle
        contentView.highlightIconColor = UIColor.fy.mainColor
        // 美化：上 inset 10 → 8，给 title 让出更舒服的位置
        contentView.insets = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        return contentView
    }

    func setupSubViewController() -> WMNavigationController? {
        guard let viewController = makeViewController() else {
            return nil
        }
        let item = ESTabBarItem(itemContentView, title: title, image: image, selectedImage: selectImage, tag: tag)
        viewController.tabBarItem = item
        viewController.hidesBottomBarWhenPushed = false
        return WMNavigationController(rootViewController: viewController)
    }
}
