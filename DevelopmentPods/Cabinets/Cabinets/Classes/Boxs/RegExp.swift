//
//  RegExp.swift
//  Cabinets
//
//  Created by Condy on 2023/5/20.
//

import Foundation

public enum RegExp {
    case Letter
    case EnglishName
    case Number
    case Decimal
    case NumberOrLetter
    case Email
    case PhoneNumber
    case StrongPassword
    case InputingEmail
    case OnlyLetterOrNumberOrChinese
    case ContainSpecialChar
    case IDCardNumber
}

extension RegExp {
    
    public var regex: String {
        switch self {
        case .Letter:
            return "[a-zA-Z]*"
        case .EnglishName:
            return "[a-zA-Z]+[a-zA-Z ]*"
        case .Number:
            return "[0-9]*"
        case .Decimal:
            return "((([1-9]{1}[0-9]*(\\.)?)|(0(\\.)))[0-9]{0,2})|0"
        case .NumberOrLetter:
            return "[a-zA-Z0-9]*"
        case .Email:
            return "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        case .PhoneNumber:
            return "1[0-9]([0-9]){9}"
        case .StrongPassword:
            return "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]+$"
        case .InputingEmail:
            return "[a-zA-Z0-9.]+@?[a-zA-Z0-9.]*"
        case .OnlyLetterOrNumberOrChinese:
            return "[A-Za-z0-9\u{4e00}-\u{9fa5}]+$"
        case .ContainSpecialChar:
            return "~!@#$%^&*()_+|<>?:\"{}[]`\\;',./！￥……（）——-=「」：”《》？·【】、；‘，。、"
        case .IDCardNumber:
            return "(^[1-9]\\d{5}(18|19|([23]\\d))\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$)|(^[1-9]\\d{5}\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{3}$)" // 18位
        }
    }
    
    public func isValidEvaluate(with string: String) -> Bool {
        switch self {
        case .ContainSpecialChar:
            let special = Array(self.regex)
            for char in Array(string) where special.contains(char) {
                return true
            }
            return false
        case .IDCardNumber:
            return isIDCardNumber(base: string)
        default:
            let predicate = NSPredicate(format: "SELF MATCHES %@", self.regex)
            return predicate.evaluate(with: string)
        }
    }
}

extension RegExp {
    
    /// 验证15位或18位身份证合法性
    func isIDCardNumber(base: String) -> Bool {
        let value = base.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if value.count != 15 && value.count != 18 {
            return false
        }
        let areasArray = [
            "11","12", "13","14", "15","21", "22","23",
            "31","32", "33","34", "35","36", "37","41",
            "42","43", "44","45", "46","50", "51","52",
            "53","54", "61","62", "63","64", "65","71",
            "81","82", "91"
        ]
        // 标识省份身份行政区代码是否正确
        if !areasArray.contains(value.substring(to: value.index(value.startIndex, offsetBy: 2))) {
            return false
        }
        var regularExpression : NSRegularExpression?
        var numberMatch: Int?
        var year = 0
        switch value.count {
        case 15:
            year = ((value as NSString).substring(with: NSRange(location: 6, length: 2)) as NSString).integerValue + 1900
            // 测试出生日期的合法性，创建正则表达式 NSRegularExpressionCaseInsensitive：不区分字母大小写的模式
            let pattern: String
            if year % 4 == 0 || (year % 100 == 0 && year % 4 == 0) {
                pattern = "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
            } else {
                pattern = "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
            }
            regularExpression = try? NSRegularExpression.init(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            numberMatch = regularExpression?.numberOfMatches(in: value, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange.init(location: 0, length: value.count))
            return (numberMatch ?? 0) > 0
        case 18:
            let value_ = value as NSString
            year = (value_.substring(with: NSRange(location: 6, length: 4)) as NSString).integerValue
            let pattern: String
            if year % 4 == 0 || (year % 100 == 0 && year % 4 == 0) {
                pattern = "^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$"
            } else {
                pattern = "^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$"
            }
            regularExpression = try? NSRegularExpression.init(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            numberMatch = regularExpression?.numberOfMatches(in: value, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange.init(location: 0, length: value.count))
            if let numberMatch = numberMatch, numberMatch > 0 {
                func getStringByRangeIntValue(Str: NSString, location: Int, length: Int) -> Int {
                    (Str.substring(with: NSRange(location: location, length: length)) as NSString).integerValue
                }
                let a = getStringByRangeIntValue(Str: value_, location: 0, length: 1) * 7
                let b = getStringByRangeIntValue(Str: value_, location: 10, length: 1) * 7
                let c = getStringByRangeIntValue(Str: value_, location: 1, length: 1) * 9
                let d = getStringByRangeIntValue(Str: value_, location: 11, length: 1) * 9
                let e = getStringByRangeIntValue(Str: value_, location: 2, length: 1) * 10
                let f = getStringByRangeIntValue(Str: value_, location: 12, length: 1) * 10
                let g = getStringByRangeIntValue(Str: value_, location: 3, length: 1) * 5
                let h = getStringByRangeIntValue(Str: value_, location: 13, length: 1) * 5
                let i = getStringByRangeIntValue(Str: value_, location: 4, length: 1) * 8
                let j = getStringByRangeIntValue(Str: value_, location: 14, length: 1) * 8
                let k = getStringByRangeIntValue(Str: value_, location: 5, length: 1) * 4
                let l = getStringByRangeIntValue(Str: value_, location: 15, length: 1) * 4
                let m = getStringByRangeIntValue(Str: value_, location: 6, length: 1) * 2
                let n = getStringByRangeIntValue(Str: value_, location: 16, length: 1) * 2
                let o = getStringByRangeIntValue(Str: value_, location: 7, length: 1) * 1
                let p = getStringByRangeIntValue(Str: value_, location: 8, length: 1) * 6
                let q = getStringByRangeIntValue(Str: value_, location: 9, length: 1) * 3
                
                let Y = (a + b + c + d + e + f + g + h + i + j + k + l + m + n + o + p + q) % 11
                let Z = NSString("10X98765432").substring(with: NSRange.init(location: Y, length: 1))
                let last = value_.substring(with: NSRange.init(location: 17, length: 1))
                return last == "x" ? Z == "X" : Z == last
            } else {
                return false
            }
        default:
            return false
        }
    }
}
