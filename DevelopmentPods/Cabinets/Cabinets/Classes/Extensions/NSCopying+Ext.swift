//
//  ExNSCopying.swift
//  FeatBox
//
//  Created by Condy on 2020/11/29.
//

import Foundation

extension BoxWrapper where Base: NSObject {
    
    /// 以类型推断的形式浅拷贝一个对象
    public func clone<T: NSCopying>(_ objectClass: T.Type = T.self) -> T? {
        return base.copy() as? T
    }
    
    /// 以类型推断的形式深拷贝一个对象
    public func mutableClone<T: NSMutableCopying>(_ objectClass: T.Type = T.self) -> T? {
        return base.mutableCopy() as? T
    }
}
