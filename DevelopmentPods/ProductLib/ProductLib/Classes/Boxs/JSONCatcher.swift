//
//  JSONCatcher.swift
//  Extensions
//
//  Created by Condy on 2023/6/9.
//

import Foundation

/// 动态成员查找
///
///     let json: [String: Any] = [
///         "name": "Rover",
///         "speed": 12,
///         "owner": ["name": "Ms. Simpson", "age": 36]
///     ]
///
///     let catcher = JSONCatcher.init(dictionary: json)
///
///     let name: String? = catcher.name // Rover
///     let messyName: String? = catcher.owner?.name // Ms. Simpson
@dynamicMemberLookup public struct JSONCatcher {
    
    public let value: Dictionary<String, Any>
    
    public init(dictionary: Dictionary<String, Any>) {
        self.value = dictionary
    }
    
    public subscript(dynamicMember member: String) -> JSONCatcher? {
        guard let val = value[member] as? Dictionary<String, Any> else {
            return nil
        }
        return JSONCatcher(dictionary: val)
    }
    
    public subscript(dynamicMember member: String) -> [JSONCatcher] {
        guard let val = value[member] as? Array<Dictionary<String, Any>> else {
            return []
        }
        return val.map { JSONCatcher(dictionary: $0) }
    }
    
    public subscript(dynamicMember member: String) -> String? {
        return value[member] as? String
    }
    
    public subscript(dynamicMember member: String) -> Int? {
        return value[member] as? Int
    }
    
    public subscript(dynamicMember member: String) -> TimeInterval? {
        return value[member] as? TimeInterval
    }
}
