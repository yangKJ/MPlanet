//
//  ExString.swift
//  FeatBox
//
//  Created by Condy on 2020/11/23.
//

import Foundation

extension BoxWrapper where Base == String {
    
    public func decimal() -> NSDecimalNumber? {
        if self.base.count == 0 {
            return nil
        }
        let decimal = NSDecimalNumber(string: base)
        if decimal == .notANumber {
            return nil
        }
        return decimal
    }
    
    public var trimmed: String {
        return base.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    public var URLEscaped: String {
        return base.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
    
    /// 安全显示字符串
    public func secureString(secureLength: Int, showSecureLength: Int = 0, fromBegin: Bool = false) -> String {
        if self.base.count < secureLength || secureLength < 0 {
            return self.base
        }
        let unSecurePrefixLength = fromBegin ? 0 : (self.base.count - secureLength)/2
        let unSecureSuffixLength = self.base.count - secureLength - unSecurePrefixLength
        let prefix = self.slicing(from: 0, length: unSecurePrefixLength)
        let suffix = self.slicing(from: unSecurePrefixLength + secureLength, length: unSecureSuffixLength)
        let secure = NSMutableString()
        if showSecureLength > 0 {
            secure.append(" ")
            for _ in 0..<showSecureLength {
                secure.append("*")
            }
            secure.append(" ")
        } else {
            for _ in 0..<secureLength {
                secure.append("*")
            }
        }
        return (prefix ?? "") + (secure as String) + (suffix ?? "")
    }
    
    public func boundingRect(with constrainedSize: CGSize, font: UIFont, lineSpacing: CGFloat? = nil) -> CGSize {
        let attritube = NSMutableAttributedString(string: base)
        let range = NSRange(location: 0, length: attritube.length)
        attritube.addAttributes([NSAttributedString.Key.font: font], range: range)
        if lineSpacing != nil {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing!
            attritube.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        }
        let rect = attritube.boundingRect(with: constrainedSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        var size = rect.size
        if let currentLineSpacing = lineSpacing {
            // 文本的高度减去字体高度小于等于行间距，判断为当前只有1行
            let spacing = size.height - font.lineHeight
            if spacing <= currentLineSpacing && spacing > 0 {
                size = CGSize(width: size.width, height: font.lineHeight)
            }
        }
        return size
    }
    
    public func boundingRect(with constrainedSize: CGSize, font: UIFont, lineSpacing: CGFloat? = nil, lines: Int) -> CGSize {
        if lines < 0 {
            return .zero
        }
        let size = boundingRect(with: constrainedSize, font: font, lineSpacing: lineSpacing)
        if lines == 0 {
            return size
        }
        let currentLineSpacing = (lineSpacing == nil) ? (font.lineHeight - font.pointSize) : lineSpacing!
        let maximumHeight = font.lineHeight*CGFloat(lines) + currentLineSpacing*CGFloat(lines - 1)
        if size.height >= maximumHeight {
            return CGSize(width: size.width, height: maximumHeight)
        }
        return size
    }
    
    public func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.base.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    public func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.base.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.width)
    }
    
    public func toDictionary() -> [String: Any]? {
        if let jsonData = base.data(using: .utf8), let dict = try? JSONSerialization.jsonObject(with: jsonData) {
            return dict as? [String : Any]
        }
        return nil
    }
}

extension BoxWrapper where Base == String {
    
    /// 每个字符之间加入`character`字符
    /// - Parameter character: 需要加入的字符
    /// - Returns: 加入之后的字符串
    public func insert(between character: String) -> String {
        base.map { "\($0)" + character }.reduce("", +)
    }
    
    /// 分割字符串
    public func slicing(from index: Int, length: Int) -> String? {
        func countableRangeString(range: CountableRange<Int>) -> String? {
            guard let lowerIndex = base.index(base.startIndex, offsetBy: max(0, range.lowerBound), limitedBy: base.endIndex),
                  let upperIndex = base.index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: base.endIndex) else {
                return nil
            }
            return String(base[lowerIndex..<upperIndex])
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
    
    public var lengthWithRare: Int {
        var number = 0
        Array(base).forEach {
            let charLength = String($0).lengthOfBytes(using: .utf8)
            if charLength == 4 {
                number += 2
            } else if charLength == 3 {
                number += 1
            } else {
                number += 1
            }
        }
        return number
    }
    
    public var lengthOfBytes: Int {
        var number = 0.0
        Array(base).forEach { (char) in
            let charLength = String(char).lengthOfBytes(using: .utf8)
            if charLength == 4 {
                number += 3
            } else if charLength == 3 {
                number += 2
            } else {
                number += 1
            }
        }
        return Int(ceil(number))
    }
    
    public func fillZero(toLength: Int) -> String {
        base.padding(toLength: toLength, withPad: "0", startingAt: 0)
    }
    
    public func substringByBytes(to: Int) -> String {
        if lengthOfBytes <= to {
            return base
        }
        var number = 0.0
        var strings = [String]()
        for char in Array(base) {
            let charLength = String(char).lengthOfBytes(using: .utf8)
            if charLength == 4 {
                number += 3
            } else if charLength == 3 {
                number += 2
            } else {
                number += 1
            }
            if Int(ceil(number)) <= to {
                strings.append(String(char))
            } else {
                break
            }
        }
        return strings.joined()
    }
    
    public func substringWithRare(to: Int) -> String {
        var number = 0
        var strings = [String]()
        for char in Array(base) {
            let charLength = String(char).lengthOfBytes(using: .utf8)
            if charLength == 4 {
                number += 2
            } else if charLength == 3 {
                number += 1
            } else {
                number += 1
            }
            if number <= to {
                strings.append(String(char))
            } else {
                break
            }
        }
        return strings.joined()
    }
    
    public func substring(maxLength: Int, addEllipsis: Bool) -> String {
        guard !base.isEmpty, base.count > maxLength else {
            return base
        }
        var maxEnd = Int.max
        var tempMaxLength = maxLength
        var range: Range<Base.Index> = base.startIndex ..< base.startIndex
        while maxEnd > maxLength {
            tempMaxLength -= 1
            range = base.rangeOfComposedCharacterSequence(at: base.index(base.startIndex, offsetBy: tempMaxLength))
            maxEnd = base.distance(from: range.lowerBound, to: range.upperBound)
        }
        guard !range.isEmpty, maxEnd != Int.max, base.count <= maxEnd else {
            return base
        }
        return String(base[range]) + (addEllipsis ? "..." : "")
    }
}
