//
//  Res.swift
//  FeatBox
//
//  Created by Condy on 2024/5/10.
//

import Foundation
import Rickenbacker

public typealias Res = Rickenbacker.Res

extension Res {

    static let moduleName = "FeatBox"

    static func image(_ named: String) -> UIImage? {
        if let image = UIImage.init(named: named) {
            return image
        }
        let bundle = readFrameworkBundle(with: Res.moduleName)
        if let image = UIImage(named: named, in: bundle, compatibleWith: nil) {
            return image
        }
        return nil
    }

    // 修复：原 `Res.jsonData(_:)` 覆写硬编码 forResource="FeatBox"，
    // 但 FeatBox bundle 内没有 json 资源，导致调用方不显式传 forResource 时
    // 永远返回空 Data。删除该覆写，强制调用方传 forResource 找到自己 module 的 bundle。
    // 历史教训：DiscoverAPI/MineAPI 调用 `Res.jsonData("User")` 走默认 FeatBox 找不到资源。
    // 现在必须显式传： `Res.jsonData("User", forResource: "WMMine")`

    static func text(_ string: String) -> String {
        self.text(string, forResource: Res.moduleName)
    }
}

extension Res {
    /// 向右箭头
    public static let right_arrow = Res.image("next")
    /// 黑色返回箭头
    public static let black_back_arrow = Res.image("back")
    /// 黑色X
    public static let black_close = Res.image("close")
    /// 无搜索数据占位图
    public static let no_search_result_image = Res.image("no_search_result_image")
    /// 网络加载失败
    public static let base_network_error_black = Res.image("base_network_error_black")
}
