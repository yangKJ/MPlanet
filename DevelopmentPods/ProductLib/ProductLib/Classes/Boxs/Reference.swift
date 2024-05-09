//
//  Reference.swift
//  Extensions
//
//  Created by Condy on 2023/6/9.
//

import Foundation

// See: https://www.swiftbysundell.com/tips/combining-dynamic-member-lookup-with-key-paths/

@dynamicMemberLookup public class Reference<Value> {
    fileprivate(set) var value: Value
    
    public init(value: Value) {
        self.value = value
    }
    
    public subscript<T>(dynamicMember keyPath: WritableKeyPath<Value, T>) -> T {
        get { value[keyPath: keyPath] }
        set { value[keyPath: keyPath] = newValue }
    }
}
