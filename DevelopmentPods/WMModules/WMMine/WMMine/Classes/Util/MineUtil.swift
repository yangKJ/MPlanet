//
//  MineUtil.swift
//  WMMine
//
//  Created by Condy on 2020/12/28.
//

import UIKit
import Rickenbacker

struct MineUtil {
    internal static let moduleName = "WMMine"
}

extension R {
    
    internal static func image(_ named: String) -> UIImage {
        self.image(named, forResource: MineUtil.moduleName)
    }
    
    internal static func text(_ string: String) -> String {
        self.text(string, forResource: MineUtil.moduleName)
    }
}
