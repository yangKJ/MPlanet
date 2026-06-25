//
//  Wrapper.swift
//  FeatBox
//
//  Created by Condy on 2021/1/2.
//

import Foundation

/// 添加 `fy` 前缀命名空间:为遵循 `BoxCompatible` 的类型提供 `value.fy.xxx` 扩展挂载点(setter 为 no-op)。
public struct BoxWrapper<Base> {
    /// Base object to extend.
    public internal(set) var base: Base
    
    /// Creates extensions with base object.
    /// - Parameter base: Base object.
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol BoxCompatible { 
    /// Extended type
    associatedtype CompatibleType
    
    /// BoxWrapper extensions.
    static var fy: BoxWrapper<CompatibleType>.Type { get }
    
    /// BoxWrapper extensions.
    var fy: BoxWrapper<CompatibleType> { get set }
}

extension BoxCompatible {
    
    public static var fy: BoxWrapper<Self>.Type {
        return BoxWrapper<Self>.self
    }
    
    public var fy: BoxWrapper<Self> {
        get { return BoxWrapper(self) }
        set { }
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
extension UINavigationController: BoxCompatible { }
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
extension UIBarButtonItem: BoxCompatible { }
extension URL: BoxCompatible { }
extension UITextField: BoxCompatible { }
extension UITextView: BoxCompatible { }
extension Character: BoxCompatible { }
extension UIDevice: BoxCompatible { }
extension NSLayoutConstraint: BoxCompatible { }
