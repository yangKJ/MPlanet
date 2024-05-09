//
//  NSObject+Ext.swift
//  FeatBox
//
//  Created by Condy on 2023/4/28.
//

import Foundation

fileprivate extension NSObject {
    /// NSObject对象获取类型
    fileprivate var runtimeType: NSObject.Type {
        type(of: self)
    }
}

extension BoxWrapper where Base: NSObject {
    
    /// 对象获取类的字符串名称
    public var className: String {
        base.runtimeType.fy.class_name
    }
    
    /// 类获取类的字符串名称
    public static var class_name: String {
        String(describing: self)
    }
}
