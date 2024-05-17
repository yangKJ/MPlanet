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
    
    public var value: [String: Any]
    
    public init(dictionary: [String: Any]) {
        self.value = dictionary
    }
    
    public init(jsonData: Data) {
        if JSONSerialization.isValidJSONObject(jsonData),
           let object = try? JSONSerialization.jsonObject(with: jsonData, options: []),
           let dictionary = object as? [String: Any] {
            self.init(dictionary: dictionary)
        } else {
            self.init(dictionary: [:])
        }
    }
    
    public init(json: String) {
        if let jsonData = json.data(using: .utf8) {
            self.init(jsonData: jsonData)
        } else {
            self.init(dictionary: [:])
        }
    }
    
    // MARK: - subscript methods
    
    public subscript(dynamicMember member: String) -> JSONCatcher? {
        guard let val = value[member] as? [String: Any] else {
            return nil
        }
        return JSONCatcher(dictionary: val)
    }
    
    public subscript(dynamicMember member: String) -> [JSONCatcher] {
        guard let val = value[member] as? [[String: Any]] else {
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
    
    public subscript(dynamicMember member: String) -> Float? {
        return value[member] as? Float
    }
    
    public subscript(dynamicMember member: String) -> CGFloat? {
        return value[member] as? CGFloat
    }
    
    public subscript(dynamicMember member: String) -> TimeInterval? {
        return value[member] as? TimeInterval
    }
    
    public subscript(dynamicMember member: String) -> Bool? {
        return value[member] as? Bool
    }
    
    public subscript(dynamicMember member: String) -> String {
        return value[member] as? String ?? ""
    }
    
    public subscript(dynamicMember member: String) -> Int {
        return value[member] as? Int ?? 0
    }
    
    public subscript(dynamicMember member: String) -> Float {
        return value[member] as? Float ?? 0.0
    }
    
    public subscript(dynamicMember member: String) -> CGFloat {
        return value[member] as? CGFloat ?? 0.0
    }
    
    public subscript(dynamicMember member: String) -> TimeInterval {
        return value[member] as? TimeInterval ?? 0.0
    }
    
    public subscript(dynamicMember member: String) -> Bool {
        return value[member] as? Bool ?? false
    }
    
    public subscript(dynamicMember member: String) -> [CGFloat] {
        guard let val = value[member] as? [CGFloat] else {
            return []
        }
        return (value[member] as? [CGFloat]) ?? []
    }
    
    public subscript(dynamicMember member: String) -> NSDecimalNumber? {
        let val = value[member]
        if let val = val as? Double {
            return NSDecimalNumber(value: val)
        }
        if let val = toString(val), isPurnFloat(val) {
            return NSDecimalNumber(string: val)
        }
        return nil
    }
    
    private func isPurnFloat(_ string: String) -> Bool {
        let scan: Scanner = Scanner(string: string)
        var val: Float = 0.0
        return scan.scanFloat(&val) && scan.isAtEnd
    }
    
    private func toString(_ any: Any?) -> String? {
        if let string = any as? String {
            return string
        }
        if let string = any as? NSNumber {
            return string.stringValue
        }
        if let string = any as? Int64 {
            return String(describing: string)
        }
        if let string = any as? Int {
            return String(describing: string)
        }
        if let string = any as? Float {
            return String(describing: string)
        }
        return nil
    }
}
