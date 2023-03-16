//
//  DiscoverUtil.swift
//  WMDiscover
//
//  Created by Condy on 2020/12/28.
//

import UIKit
import Rickenbacker

struct DiscoverUtil {
    internal static let moduleName = "WMDiscover"
}

extension Rickenbacker.R {
    internal static func image(_ named: String) -> UIImage {
        self.image(named, forResource: DiscoverUtil.moduleName)
    }
}
