//
//  ExOptional.swift
//  FeatBox
//
//  Created by Condy on 2020/11/23.
//

import Foundation

extension Optional {
    
    /// 过滤可选项为nil的情况
    ///
    /// - Parameter valueOnNil: 可选项为空时的默认值
    /// - Returns: 解包后的值
    public func filterNil(_ valueOnNil: Wrapped) -> Wrapped {
        switch self {
        case .some(let value):
            return value
        case .none:
            return valueOnNil
        }
    }
}

#if DEBUG
public let StringOnNil = "undefined"
#else
public let StringOnNil = ""
#endif

extension Optional where Wrapped == String {
    
    public var isBlank: Bool {
        switch self {
        case .some(let value):
            return value.cdy.isBlank
        case .none:
            return true
        }
    }
    
    public var isNotBlank: Bool {
        return !(self?.cdy.isBlank ?? true)
    }
    
    public var length: Int {
        switch self {
        case .some(let value):
            return value.count
        case .none:
            return 0
        }
    }
    
    public var trimmed: String? {
        switch self {
        case .some(let value):
            return value.cdy.trimmed
        case .none:
            return nil
        }
    }
    
    public func filterNil(_ valueOnNil: String = StringOnNil) -> String {
        switch self {
        case .some(let value):
            return value
        case .none:
            return valueOnNil
        }
    }
}
