//
//  Routerable.swift
//  FeatBox
//
//  Created by Condy on 2024/5/10.
//

import Foundation
import Mediator

public enum CustomizedGotoType: String {
    case web = "WEB"
    case url = "URL"
    case function = "FUNCTION"
    case applets = "APPLETS"
    case tabBar = "TAB_BAR"
    case none = "NONE"
}

/// 通用路由跳转
public protocol Routerable {
    // 跳转类型 WEB-网址链接、FUNCTION-原生功能、APPLETS-小程序、TAB_BAR-标签页、URL-外部应用等
    var gotoType: String? { get set }
    // 跳转对象，WEB对应链接；FUNCTION对应App功能标识；TAB_BAR对应的名称；
    var gotoObject: String? { get set }
    // why: 路由表设计为 (gotoType, gotoObject) 双字段,
    // 后端下发统一的 JSON 跳转配置即可让原生路由到 WEB / 小程序 / 原生页 / TabBar 等。
    // 字符串而非枚举是为了兼容后端动态下发 & 旧版本字段,枚举解析在 CustomizedGotoType 里完成。
}

extension Routerable {
    
    public var gotoTypeEnum: CustomizedGotoType? {
        guard let gotoType = gotoType else {
            return nil
        }
        return CustomizedGotoType.init(rawValue: gotoType)
    }
    
    private var functionType: FunctionType? {
        guard let gotoObject = gotoObject else {
            return nil
        }
        return FunctionType(rawValue: gotoObject)
    }
    
    /// 通用跳转模块:根据 `gotoType` 派发到 WEB / URL / FUNCTION / APPLETS / TAB_BAR。
    @discardableResult
    public func goto(from vc: UIViewController? = nil, additional: Any? = nil) -> Bool {
        guard let gotoTypeEnum = self.gotoTypeEnum else {
            return false
        }
        switch gotoTypeEnum {
        case .web:
            return true
        case .url:
            return true
        case .function:
            guard let functionType = functionType else {
                return false
            }
            return functionType.goto(from: vc, additional: additional)
        case .applets:
            return true
        case .tabBar:
            return Mediator.gotoTabBarIndex(with: gotoObject)
        case .none:
            return true
        }
        return false
    }
}
