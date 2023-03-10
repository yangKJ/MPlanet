//
//  ExDispatchTime.swift
//  FeatBox
//
//  Created by Condy on 2020/11/23.
//

import Foundation

extension DispatchTime: ExpressibleByIntegerLiteral {
    /// Creates DispatchTime instance using integer literal
    ///
    /// - Parameter value: delay seconds
    /// - Useage DispatchTime(integerLiteral: 3) is equivalent to 3
    public init(integerLiteral value: Int) {
        self = DispatchTime.now() + .seconds(value)
    }
}

extension DispatchTime: ExpressibleByFloatLiteral {
    /// Creates DispatchTime instance using float literal
    ///
    /// - Parameter value: delay seconds
    /// - Useage DispatchTime(floatLiteral: 3.0) is equivalent to 3.0
    public init(floatLiteral value: Double) {
        self = DispatchTime.now() + .milliseconds(Int(value * 1000))
    }
}

extension DispatchWallTime: ExpressibleByIntegerLiteral {
    /// Creates DispatchWallTime instance using integer literal
    ///
    /// - Parameter value: delay seconds
    /// - Useage DispatchWallTime(integerLiteral: 3) is equivalent to 3
    public init(integerLiteral value: Int) {
        self = DispatchWallTime.now() + .seconds(value)
    }
}

extension DispatchWallTime: ExpressibleByFloatLiteral {
    /// Creates DispatchWallTime instance using float literal
    ///
    /// - Parameter value: delay seconds
    /// - Useage DispatchWallTime(floatLiteral: 3.0) is equivalent to 3.0
    public init(floatLiteral value: Double) {
        self = DispatchWallTime.now() + .milliseconds(Int(value * 1000))
    }
}
