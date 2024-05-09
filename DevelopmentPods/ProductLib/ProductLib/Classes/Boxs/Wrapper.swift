//
//  Wrapper.swift
//  FeatBox
//
//  Created by Condy on 2021/1/2.
//

import Foundation

/// 添加 `fy` 前缀命名空间
public struct BoxWrapper<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol BoxCompatible { }

extension BoxCompatible {
    public var fy: BoxWrapper<Self> {
        get { return BoxWrapper(self) }
        set { }
    }
    public static var fy: BoxWrapper<Self>.Type {
        BoxWrapper<Self>.self
    }
}

extension NSObject: BoxCompatible { }
extension UIColor: BoxCompatible { }
extension String: BoxCompatible { }
extension Array: BoxCompatible { }
extension Dictionary: BoxCompatible { }
extension Bool: BoxCompatible { }
extension CALayer: BoxCompatible { }
extension DispatchQueue: BoxCompatible { }
extension UIButton: BoxCompatible { }
extension UIImage: BoxCompatible { }
extension UIViewController: BoxCompatible { }
extension UIEdgeInsets: BoxCompatible { }
extension UIView: BoxCompatible { }
extension Int: BoxCompatible { }
extension Double: BoxCompatible { }
extension CGFloat: BoxCompatible { }
extension NSDecimalNumber: BoxCompatible { }
extension UIFont: BoxCompatible { }
extension UILabel: BoxCompatible { }
extension UIWindow: BoxCompatible { }
extension Date: BoxCompatible { }
extension NSAttributedString: BoxCompatible { }
