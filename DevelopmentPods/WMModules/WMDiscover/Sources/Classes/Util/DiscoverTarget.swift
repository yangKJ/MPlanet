//
//  DiscoverTarget.swift
//  WMDiscover
//
//  Created by Condy on 2020/12/28.
//

import UIKit
import FeatBox

/// 配置`Target`供外界组件调用
@objc public final class DiscoverTarget: NSObject {

    @objc public func getDiscoverViewControllerType() -> UIViewController.Type {
        return DiscoverViewController.self
    }

    /// WMTabBarItem.makeViewController() 调用此方法
    @objc public func Action_viewController(_ params: [String: Any]?) -> UIViewController {
        return DiscoverViewController()
    }

    @objc public func setupDiscoverViewController() -> UIViewController? {
        let vc = DiscoverViewController.init()
        return vc
    }
    
    @objc public func bannerDetailViewController(_ param: [String: Any]?) -> UIViewController? {
        let vc = BannerDetailViewController.init()
        if let index = param?["index"] as? Int {
            vc.index = index
        }
        if let banners = param?["banners"] as? [Banner] {
            vc.list = banners
        }
        return vc
    }
}
