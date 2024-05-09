//
//  Date+Format.swift
//  Extensions
//
//  Created by Condy on 2023/10/8.
//

import Foundation

extension BoxWrapper where Base == Date {
    
    public enum DateFormat: String {
        case yyyy = "yyyy"
        case yyyy_p_mm_p_dd = "yyyy.MM.dd"
        case mm_p_dd = "MM.dd"
        case yyyy_p_mm = "yyyy.MM"
        case yyyy_p_mm_p_dd_hh_mm = "yyyy.MM.dd HH:mm"
        case yyyy_mm = "yyyyMM"
        case yyyy_mm_dd = "yyyy-MM-dd"
        case yyyy_virgule_mm_virgule_dd = "yyyy/MM/dd"
        case mm_dd = "MM-dd"
        case mmdd = "MMdd"
        case yymm = "yyMM"
        case yyyymmdd = "yyyyMMdd"
        case yyyymmddhhkmmss = "yyyyMMddHHmmss"
        case yyyy_mm_dd_CH = "yyyy年MM月dd日"
        case yyyy_m_d_CH = "yyyy年M月d日"
        case yyyy_mm_dd_hh_mm_ss_CH = "yyyy年MM月dd日 HH:mm:ss"
        case mm_dd_hh_mm_ss_CH = "MM月dd日 HH:mm:ss"
        case yyyym_CH = "yyyy年M月"
        case yyyy_mm_dd_hh_mm_ss = "yyyy-MM-dd HH:mm:ss"
        case yyyy_mm_dd_hh_mm = "yyyy-MM-dd HH:mm"
    }
    
    /// Date format string
    /// - Parameter type: Type of format.
    /// - Returns: String.
    public func format(with type: DateFormat) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh-Hans-CN")
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.short
        formatter.dateFormat = type.rawValue
        return formatter.string(from: base)
    }
    
    /// String to date.
    /// - Parameters:
    ///   - type: Type of format.
    ///   - string: Date string.
    /// - Returns: Date.
    public static func date(with type: DateFormat, string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh-Hans-CN")
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.short
        formatter.dateFormat = type.rawValue
        return formatter.date(from: string)
    }
}
