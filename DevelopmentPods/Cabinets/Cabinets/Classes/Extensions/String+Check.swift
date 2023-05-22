//
//  String+Check.swift
//  FeatBox
//
//  Created by Condy on 2023/4/28.
//

import Foundation

extension BoxWrapper where Base == String {
    
    public func isMatched(_ regex: String) -> Bool {
        guard let regular = try? NSRegularExpression(pattern: regex, options: []),
              let result = regular.firstMatch(in: base, options: [], range: NSRange(location: 0, length: base.count)) else {
            return false
        }
        return result.range.location != NSNotFound
    }
    
    public func isMatched(_ regex: String, condition: (String) -> Bool) -> Bool {
        guard let regular = try? NSRegularExpression(pattern: regex, options: []) else {
            return false
        }
        let results = regular.matches(in: base, options: [], range: NSRange(location: 0, length: base.count))
        let subs: [String] = results.compactMap({
            let sub = (base as NSString).substring(with: $0.range)
            return condition(sub) ? sub : nil
        })
        return subs.count > 0
    }
    
    public var isContainIDCardNumber: Bool {
        let regex = "[1-9][0-9]+[0-9Xx]"
        return isMatched(regex, condition: { $0.count >= 15 && $0.count <= 18 })
    }
    
    public var isContainPhoneNumber: Bool {
        let regex = "1[0-9]+"
        return isMatched(regex, condition: { $0.count == 11 })
    }
    
    public var isContainBankCardNumber: Bool {
        let regex = "[0-9]+"
        return isMatched(regex, condition: { $0.count >= 8 && $0.count <= 32 })
    }
    
    public var isContainAmount: Bool {
        let regex = "[点元块角毛分十百千万亿一二三四五六七八九十零壹贰叁肆伍陆柒扒玖拾0-9\\.]+"
        return isMatched(regex)
    }
    
    public var isChinese: Bool {
        if "\u{4E00}" <= base && base <= "\u{9FA5}" {
            return true
        }
        return false
    }
    
    public var isValidLetter: Bool {
        RegExp.Letter.isValidEvaluate(with: base)
    }
    
    public var isValidEnglishName: Bool {
        RegExp.EnglishName.isValidEvaluate(with: base)
    }
    
    public var isValidNumber: Bool {
        RegExp.Number.isValidEvaluate(with: base)
    }
    
    public var isValidDecimal: Bool {
        RegExp.Decimal.isValidEvaluate(with: base)
    }
    
    public var isValidNumberOrLetter: Bool {
        RegExp.NumberOrLetter.isValidEvaluate(with: base)
    }
    
    public var isValidEmail: Bool {
        RegExp.Email.isValidEvaluate(with: base)
    }
    
    public var isValidPhoneNumber: Bool {
        RegExp.PhoneNumber.isValidEvaluate(with: base)
    }
    
    public var isStrongPassword: Bool {
        RegExp.StrongPassword.isValidEvaluate(with: base)
    }
    
    public var isValidInputingEmail: Bool {
        RegExp.InputingEmail.isValidEvaluate(with: base)
    }
    
    public var isOnlyLetterOrNumberOrChinese: Bool {
        RegExp.OnlyLetterOrNumberOrChinese.isValidEvaluate(with: base)
    }
    
    /// 包含特殊字符
    public var containSpecialChar: Bool {
        RegExp.ContainSpecialChar.isValidEvaluate(with: base)
    }
    
    /// 验证15位或18位身份证合法性
    public var isValidIDCardNumber: Bool {
        RegExp.IDCardNumber.isValidEvaluate(with: base)
    }
}
