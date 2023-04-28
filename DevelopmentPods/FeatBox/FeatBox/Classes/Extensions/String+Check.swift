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
    
    public var isValidLetter: Bool {
        let regex = "[a-zA-Z]*"
        let presicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return presicate.evaluate(with: base)
    }
    
    public var isValidEnglishName: Bool {
        let regex = "[a-zA-Z]+[a-zA-Z ]*"
        let presicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return presicate.evaluate(with: base)
    }
    
    public var isValidNumber: Bool {
        let regex = "[0-9]*"
        let presicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return presicate.evaluate(with: base)
    }
    
    public var isValidDecimal: Bool {
        let regex = "((([1-9]{1}[0-9]*(\\.)?)|(0(\\.)))[0-9]{0,2})|0"
        let presicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return presicate.evaluate(with: base)
    }
    
    public var isValidNumberOrLetter: Bool {
        let regex = "[a-zA-Z0-9]*"
        let presicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return presicate.evaluate(with: base)
    }
    
    public var isValidEmail: Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let presicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return presicate.evaluate(with: base)
    }
    
    public var isValidPhoneNumber: Bool {
        let regex = "1[0-9]([0-9]){9}"
        let presicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return presicate.evaluate(with: base)
    }
    
    public var isStrongPassword: Bool {
        let regex = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]+$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: base)
    }
    
    public var isValidInputingEmail: Bool {
        let regex = "[a-zA-Z0-9.]+@?[a-zA-Z0-9.]*"
        let presicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return presicate.evaluate(with: base)
    }
    
    public var isOnlyLetterOrNumberOrChinese: Bool {
        let regex = "[A-Za-z0-9\u{4e00}-\u{9fa5}]+$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: base)
    }
    
    public var isChinese: Bool {
        if "\u{4E00}" <= base && base <= "\u{9FA5}" {
            return true
        }
        return false
    }
    
    /// 包含特殊字符
    public var containSpecialChar: Bool {
        let special = Array("~!@#$%^&*()_+|<>?:\"{}[]`\\;',./！￥……（）——-=「」：”《》？·【】、；‘，。、")
        for char in Array(base) where special.contains(char) {
            return true
        }
        return false
    }
    
    /// 验证15位或18位身份证合法性
    public var isValidIDCardNumber: Bool {
        var value = base
        value = value.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        var length : Int = 0
        length = value.count
        if length != 15 && length != 18 {
            return false
        }
        // 省份代码
        let areasArray = [
            "11","12", "13","14", "15","21", "22","23",
            "31","32", "33","34", "35","36", "37","41",
            "42","43", "44","45", "46","50", "51","52",
            "53","54", "61","62", "63","64", "65","71",
            "81","82", "91"
        ]
        // 检测省份身份行政区代码
        let index = value.index(value.startIndex, offsetBy: 2)
        let valueStart2 = value.substring(to: index)
        //标识省份代码是否正确
        var areaFlag = false
        for areaCode in areasArray {
            if areaCode == valueStart2 {
                areaFlag = true
                break
            }
        }
        if !areaFlag {
            return false
        }
        var regularExpression : NSRegularExpression?
        var numberofMatch : Int?
        var year = 0
        switch length {
        case 15:
            //获取年份对应的数字
            let valueNSStr = value as NSString
            let yearStr = valueNSStr.substring(with: NSRange.init(location: 6, length: 2)) as NSString
            year = yearStr.integerValue + 1900
            if year % 4 == 0 || (year % 100 == 0 && year % 4 == 0) {
                //创建正则表达式 NSRegularExpressionCaseInsensitive：不区分字母大小写的模式
                //测试出生日期的合法性
                regularExpression = try! NSRegularExpression.init(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$", options: NSRegularExpression.Options.caseInsensitive)
            } else {
                //测试出生日期的合法性
                regularExpression = try! NSRegularExpression.init(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$", options: NSRegularExpression.Options.caseInsensitive)
            }
            numberofMatch = regularExpression?.numberOfMatches(in: value, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange.init(location: 0, length: value.count))
            return numberofMatch! > 0
        case 18:
            let valueNSStr = value as NSString
            let yearStr = valueNSStr.substring(with: NSRange.init(location: 6, length: 4)) as NSString
            year = yearStr.integerValue
            if year % 4 == 0 || (year % 100 == 0 && year % 4 == 0) {
                //测试出生日期的合法性
                regularExpression = try! NSRegularExpression.init(pattern: "^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$", options: NSRegularExpression.Options.caseInsensitive)
            } else {
                //测试出生日期的合法性
                regularExpression = try! NSRegularExpression.init(pattern: "^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$", options: NSRegularExpression.Options.caseInsensitive)
            }
            numberofMatch = regularExpression?.numberOfMatches(in: value, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange.init(location: 0, length: value.count))
            if numberofMatch! > 0 {
                func getStringByRangeIntValue(Str: NSString, location: Int, length: Int) -> Int {
                    let a = Str.substring(with: NSRange(location: location, length: length))
                    let intValue = (a as NSString).integerValue
                    return intValue
                }
                let a = getStringByRangeIntValue(Str: valueNSStr, location: 0, length: 1) * 7
                let b = getStringByRangeIntValue(Str: valueNSStr, location: 10, length: 1) * 7
                let c = getStringByRangeIntValue(Str: valueNSStr, location: 1, length: 1) * 9
                let d = getStringByRangeIntValue(Str: valueNSStr, location: 11, length: 1) * 9
                let e = getStringByRangeIntValue(Str: valueNSStr, location: 2, length: 1) * 10
                let f = getStringByRangeIntValue(Str: valueNSStr, location: 12, length: 1) * 10
                let g = getStringByRangeIntValue(Str: valueNSStr, location: 3, length: 1) * 5
                let h = getStringByRangeIntValue(Str: valueNSStr, location: 13, length: 1) * 5
                let i = getStringByRangeIntValue(Str: valueNSStr, location: 4, length: 1) * 8
                let j = getStringByRangeIntValue(Str: valueNSStr, location: 14, length: 1) * 8
                let k = getStringByRangeIntValue(Str: valueNSStr, location: 5, length: 1) * 4
                let l = getStringByRangeIntValue(Str: valueNSStr, location: 15, length: 1) * 4
                let m = getStringByRangeIntValue(Str: valueNSStr, location: 6, length: 1) * 2
                let n = getStringByRangeIntValue(Str: valueNSStr, location: 16, length: 1) * 2
                let o = getStringByRangeIntValue(Str: valueNSStr, location: 7, length: 1) * 1
                let p = getStringByRangeIntValue(Str: valueNSStr, location: 8, length: 1) * 6
                let q = getStringByRangeIntValue(Str: valueNSStr, location: 9, length: 1) * 3
                let S = a + b + c + d + e + f + g + h + i + j + k + l + m + n + o + p + q
                let Y = S % 11
                var M = "F"
                let JYM = "10X98765432"
                M = (JYM as NSString).substring(with: NSRange.init(location: Y, length: 1))
                let lastStr = valueNSStr.substring(with: NSRange.init(location: 17, length: 1))
                if lastStr == "x" {
                    return M == "X"
                } else {
                    return M == lastStr
                }
            } else {
                return false
            }
        default:
            return false
        }
    }
}
