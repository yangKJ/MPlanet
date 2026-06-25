//
//  Dictionary+Ext.swift
//  ProductLib
//
//  Created by Condy on 2025/5/20.
//

import Foundation

extension Dictionary {
    
    public func toJSONString() -> String? {
        if let data = try? JSONSerialization.data(withJSONObject: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}

extension BoxWrapper where Base == [AnyHashable: Any] {
    
    public mutating func merge<S: Sequence>(_ other: S) where S.Iterator.Element == (key: Base.Key, value: Base.Value) {
        for (key, value) in other {
            base[key] = value
        }
    }
}
