//
//  DiscoverTarget.swift
//  WMDiscover
//
//  Created by Condy on 2020/12/28.
//

import UIKit

class DiscoverTarget: NSObject {
    
    /// 配置`Target`供外界组件调用
    @objc public func setupDiscoverViewController() -> UIViewController? {
        let vc = DiscoverViewController.init()
        return vc
    }
}
