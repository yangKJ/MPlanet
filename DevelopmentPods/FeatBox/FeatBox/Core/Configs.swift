//
//  Configs.swift
//  FeatBox
//
//  Created by Condy on 2024/5/10.
//

import Foundation

@_exported import ProductLib
@_exported import Rickenbacker
@_exported import SnapKit
@_exported import RxSwift
@_exported import RxCocoa
@_exported import RxGesture
@_exported import Booming
@_exported import HandyJSON

public struct Configs {
    
    public static let moduleName = "FeatBox"
    
    /// 初始化标准模式配置
    public static func initStandardConfigs() {
        BoomingSetup.animatedJSON = "StandardLoading"
    }
}
