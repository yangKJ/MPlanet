//
//  MineUtil.swift
//  WMMine
//
//  Created by Condy on 2020/12/28.
//

import UIKit
import Rickenbacker

struct MineUtil {
    static let moduleName = "WMMine"
}

extension Rickenbacker.R {
    
    static func image(_ named: String) -> UIImage {
        self.image(named, forResource: MineUtil.moduleName)
    }
    
    static func text(_ string: String) -> String {
        self.text(string, forResource: MineUtil.moduleName)
    }
}
