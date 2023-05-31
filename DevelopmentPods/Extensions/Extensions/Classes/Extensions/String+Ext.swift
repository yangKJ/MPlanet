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
    
    /// 分割字符串
    public func slicing(from index: Int, length: Int, whenLength: Int) -> String? {
        guard self.base.count == whenLength else {
            return base
        }
        guard length >= 0, index >= 0, index < base.count else {
            return nil
        }
        guard index.advanced(by: length) <= base.count else {
            return countableRangeString(range: index..<base.count)
        }
        guard length > 0 else {
            return ""
        }
        return countableRangeString(range: index..<index.advanced(by: length))
    }
    
    func countableRangeString(range: CountableRange<Int>) -> String? {
        guard let lowerIndex = base.index(base.startIndex, offsetBy: max(0, range.lowerBound), limitedBy: base.endIndex),
              let upperIndex = base.index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: base.endIndex) else {
            return nil
        }
        return String(base[lowerIndex..<upperIndex])
    }
}
