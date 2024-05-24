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
        func countableRangeString(range: CountableRange<Int>) -> String? {
            guard let lowerIndex = base.index(base.startIndex, offsetBy: max(0, range.lowerBound), limitedBy: base.endIndex),
                  let upperIndex = base.index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: base.endIndex) else {
                return nil
            }
            return String(base[lowerIndex..<upperIndex])
        }
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
    
    /// Verify that the URL format is correct.
    public func verifyLink() -> Bool {
        do {
            let dataDetector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let options = NSRegularExpression.MatchingOptions(rawValue: 0)
            let res = dataDetector.matches(in: base, options: options, range: NSMakeRange(0, base.count))
            if res.count == 1 && res[0].range.location == 0 && res[0].range.length == base.count {
                return true
            }
        } catch { }
        return false
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
}
