//
//  String+Check.swift
//  FeatBox
//
//  Created by Condy on 2023/4/28.
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
    
    /// Verify that the URL format is correct.
    public func verifyLink() -> Bool {
        guard let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return false
        }
        let options = NSRegularExpression.MatchingOptions(rawValue: 0)
        let res = dataDetector.matches(in: base, options: options, range: NSMakeRange(0, base.count))
        return res.count == 1 && res[0].range.location == 0 && res[0].range.length == base.count
    }
}

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
        let substrings: [String] = results.compactMap {
            let sub = (base as NSString).substring(with: $0.range)
            return condition(sub) ? sub : nil
        }
        return substrings.count > 0
    }
    
    public var containsOnlyDigits: Bool {
        let notDigits = NSCharacterSet.decimalDigits.inverted
        let option = String.CompareOptions.literal
        return base.rangeOfCharacter(from: notDigits, options: option, range: nil) == nil
    }
    
    public var isAlphanumeric: Bool {
        !base.isEmpty && base.range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
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
    
    public var containsFullWidth: Bool {
        for scalar in self.base.unicodeScalars {
            let value = Int(scalar.value)
            if (value > 65280 && value < 65375 && value != 65281 && value != 65288 && value != 65289 && value != 65292 && value != 65306 && value != 65307 && value != 65311) || value == 12288 {
                return true
            }
        }
        return false
    }
    
    public var containEnglishSpecialChar: Bool {
        let special = Array("-/:;()$&@\".,?!'[]{}#%^*+=_\\|~<>€£¥")
        for char in Array(base) {
            if special.contains(char) {
                return true
            }
        }
        return false
    }
    
    public var containsEmoji: Bool {
        for scalar in base.unicodeScalars {
            if #available(iOS 10.2, *) {
                if scalar.properties.isEmoji {
                    return true
                }
            } else {
                switch scalar.value {
                case 0x1F600...0x1F64F, // Emoticons
                    0x1F300...0x1F5FF, // Misc Symbols and Pictographs
                    0x1F680...0x1F6FF, // Transport and Map
                    0x2600...0x26FF,   // Misc symbols
                    0x2700...0x27BF,   // Dingbats
                    0xFE00...0xFE0F,   // Variation Selectors
                    0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
                    0x1F1E6...0x1F1FF: // Flags
                    return true
                default:
                    continue
                }
            }
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
