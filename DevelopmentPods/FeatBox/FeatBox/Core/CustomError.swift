//
//  CustomError.swift
//  FeatBox
//
//  Created by Condy on 2024/5/20.
//

import Foundation
import LocalAuthentication

/// 所有错误均使用此枚举
public enum CustomError {
    case error(Error)
    case unknown
    case deviceError(LAError)
}

extension CustomError: CustomStringConvertible {
    /// For each error type return the appropriate description.
    public var description: String {
        localizedDescription
    }
    
    /// A textual representation of `self`, suitable for debugging.
    public var localizedDescription: String {
        switch self {
        case .error(let err):
            return err.localizedDescription
        case .unknown:
            return Res.text("未知错误")
        case .deviceError(let err):
            return err.localizedDescription
        }
    }
}

