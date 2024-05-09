//
//  ImportFile.swift
//  FeatBox
//
//  Created by Condy on 2021/1/25.
//

import UIKit
import Dispatch
import Foundation

@_exported import ProductLib
@_exported import Rickenbacker
@_exported import SnapKit
@_exported import RxSwift
@_exported import RxCocoa
@_exported import RxGesture
@_exported import Booming

struct FeatBoxUtil {
    static let moduleName = "FeatBox"
}

public typealias Res = Rickenbacker.R
public typealias Ces = Rickenbacker.C

extension Res {
    
    static func image(_ named: String) -> UIImage {
        self.image(named, forResource: FeatBoxUtil.moduleName)
    }
    
    static func jsonData(_ named: String) -> Data {
        self.jsonData(named, forResource: FeatBoxUtil.moduleName) ?? Data()
    }
    
    static func text(_ string: String) -> String {
        self.text(string, forResource: FeatBoxUtil.moduleName)
    }
}

extension Res {
    
    /// 网络失败占位图
    public static let base_network_error_black = Res.readImage("base_network_error_black")!
}
