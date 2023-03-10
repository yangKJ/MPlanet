//
//  Toggle.swift
//  FeatBox
//
//  Created by Condy on 2021/1/10.
//

import Foundation

/// 开关小工具
public protocol Togglable {
    mutating func toggle()
}

public enum OnOffSwitch: Togglable {
    case OFF, ON
    mutating public func toggle() {
        switch self {
        case .OFF:
            self = .ON
        case .ON:
            self = .OFF
        }
    }
}
