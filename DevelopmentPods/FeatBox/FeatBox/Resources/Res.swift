//
//  Res.swift
//  FeatBox
//
//  Created by Condy on 2024/5/10.
//

import Foundation
import Rickenbacker

public typealias Res = Rickenbacker.R
public typealias Ces = Rickenbacker.C

extension Res {
    
    static func image(_ named: String) -> UIImage {
        self.image(named, forResource: Configs.moduleName)
    }
    
    static func jsonData(_ named: String) -> Data {
        self.jsonData(named, forResource: Configs.moduleName) ?? Data()
    }
    
    static func text(_ string: String) -> String {
        self.text(string, forResource: Configs.moduleName)
    }
}

extension Res {
    /// 黑色返回箭头
    public static let black_back_arrow = Res.image("back")
    /// 网络失败占位图
    public static let base_network_error_black = Res.readImage("base_network_error_black") ?? UIImage()
    /// 无搜索数据占位图
    public static let no_search_result_image = Res.image("no_search_result_image")
}
