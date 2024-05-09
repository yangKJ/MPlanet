//
//  SwizzleAppDelegate.swift
//  RootManager
//
//  Created by Condy on 2023/5/20.
//

import Foundation
import FeatBox

/// 方法交换处理相关，第一个执行
class SwizzleAppDelegate: AppDelegateType {
 
    weak var keyWindow: UIWindow?
    
    init(window: UIWindow?) {
        self.keyWindow = window
        super.init()
        self.setupAwares()
    }
    
    private func setupAwares() {
        
    }
}
