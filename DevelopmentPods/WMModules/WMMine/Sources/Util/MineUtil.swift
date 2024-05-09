//
//  MineUtil.swift
//  WMMine
//
//  Created by Condy on 2020/12/28.
//

import UIKit
import FeatBox

struct MineUtil {
    static let moduleName = "WMMine"
}

extension Res {
    
    static func image(_ named: String) -> UIImage {
        self.image(named, forResource: MineUtil.moduleName)
    }
    
    static func jsonData(_ named: String) -> Data {
        self.jsonData(named, forResource: MineUtil.moduleName) ?? Data()
    }
    
    static func text(_ string: String) -> String {
        self.text(string, forResource: MineUtil.moduleName)
    }
}
