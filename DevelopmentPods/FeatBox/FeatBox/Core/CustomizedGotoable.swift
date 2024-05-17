//
//  CustomizedGotoable.swift
//  FeatBox
//
//  Created by Condy on 2024/5/10.
//

import Foundation
import Mediator

public enum CustomizedGotoType: String {
    case web = "WEB"
    case url = "URL" // 外部应用等
    case function = "FUNCTION"
    case applets = "APPLETS"
    case tabBar = "TAB_BAR"
    case none = "NONE"
}

public protocol CustomizedGotoable {
    // 跳转类型 WEB-网址链接、FUNCTION-原生功能、APPLETS-小程序、TAB_BAR-标签页
    var gotoType: String? { get set }
    // 跳转对象，WEB对应链接；FUNCTION对应App功能标识；TAB_BAR对应的名称；
    var gotoObject: String? { get set }
}

extension CustomizedGotoable {
    
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
    
    /// 通用跳转模块
    /// - Parameters:
    ///   - vc: 来源控制器
    ///   - additional: 额外的参数
    ///   - logined: 是否需要登陆
    /// - Returns: 是否已经处理
    @discardableResult
    public func goto(from vc: UIViewController? = nil, additional: Any? = nil, logined: Bool = false) -> Bool {
        guard let gotoTypeEnum = self.gotoTypeEnum else {
            return false
        }
        switch gotoTypeEnum {
        case .web:
            break
        case .url:
            break
        case .function:
            if let functionType = functionType, let additional = additional as? [String: Any] {
                return functionType.goto(from: vc, additional: additional, logined: logined)
            }
        case .applets:
            break
        case .tabBar:
            return Mediator.gotoTabBarIndex(with: gotoObject) ?? false
        case .none:
            break
        }
        return true
    }
}
