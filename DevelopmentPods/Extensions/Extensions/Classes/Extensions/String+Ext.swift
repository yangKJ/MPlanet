//
//  ExString.swift
//  FeatBox
//
//  Created by Condy on 2020/11/23.
//

import Foundation

extension BoxWrapper where Base == String {
    
    public var isBlank: Bool {
        let blanks = [
            "NIL", "Nil", "nil", "NULL", "Null", "null", "(NULL)", "(Null)", "(null)", "<NULL>", "<Null>", "<null>"
        ]
        return base.isEmpty || base.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty || blanks.contains(base)
    }
    
    public var isNotBlank: Bool {
        return !isBlank
    }
    
    public var trimmed: String {
        return base.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    public var URLEscaped: String {
        return base.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
    
    /// 每个字符之间加入`character`字符
    /// - Parameter character: 需要加入的字符
    /// - Returns: 加入之后的字符串
    public func insert(between character: String) -> String {
        base.map { "\($0)" + character }.reduce("", +)
    }
}
