//
//  DiscoverUtil.swift
//  WMDiscover
//
//  Created by Condy on 2020/12/28.
//

import UIKit
import Rickenbacker

struct DiscoverUtil {
    static let moduleName = "WMDiscover"
}

extension Rickenbacker.R {
    
    static func image(_ named: String) -> UIImage {
        self.image(named, forResource: DiscoverUtil.moduleName)
    }
    
    static func jsonData(_ named: String) -> Data {
        self.jsonData(named, forResource: DiscoverUtil.moduleName) ?? Data()
    }
    
    static func text(_ string: String) -> String {
        self.text(string, forResource: DiscoverUtil.moduleName)
    }
}
