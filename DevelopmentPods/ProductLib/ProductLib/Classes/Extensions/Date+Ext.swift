//
//  Date+Ext.swift
//  Extensions
//
//  Created by Condy on 2023/10/8.
//

import Foundation

extension BoxWrapper where Base == Date {
    
    public var millisecondTimeIntervalSince1970: TimeInterval {
        return ceil(base.timeIntervalSince1970*1000)
    }
    
    public static var calendar: Calendar {
        Calendar(identifier: Calendar.current.identifier)
    }
    
    /// 中国时区，时间戳都是一样
    public static var localCalender: Calendar {
        var calender = Calendar(identifier: Calendar.Identifier.gregorian)
        calender.locale = Locale(identifier: "zh-Hans-CN")
        return calender
    }
    
    public func dateComponents() -> DateComponents {
        let types: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second, .quarter, .weekOfMonth, .weekOfYear]
        return Calendar.current.dateComponents(types, from: base)
    }
    
    public var localYear: Int {
        get {
            return Date.fy.localCalender.component(.year, from: base)
        }
        set {
            guard newValue > 0 else { return }
            let currentYear = Date.fy.localCalender.component(.year, from: base)
            let yearsToAdd = newValue - currentYear
            if let date = Date.fy.localCalender.date(byAdding: .year, value: yearsToAdd, to: base) {
                self = BoxWrapper.init(date)
            }
        }
    }
    
    public func ageOf(birthday: Date) -> Int {
        let nowMonth = base.fy.month
        let birthMonth = birthday.fy.month
        var baseYearAge = base.fy.localYear - birthday.fy.localYear
        if nowMonth < birthMonth {
            baseYearAge -= 1
        } else if nowMonth == birthMonth {
            if base.fy.day < birthday.fy.day {
                baseYearAge -= 1
            }
        }
        if baseYearAge < 0 {
            return 0
        }
        return baseYearAge
    }
    
    /// Date by adding multiples of calendar component.
    /// - Parameters:
    ///   - component: A single component to add.
    ///   - value: The value of the specified component to add.
    ///   - isChain: Is it China's time zone, 中国时区和大西洋时区有8小时时差
    /// - Returns: Original date + multiples of component added. 当日期溢出时返回 nil。
    public func adding(_ component: Calendar.Component, value: Int, isChain: Bool = true) -> Date? {
        let calender = isChain ? Date.fy.localCalender : Date.fy.calendar
        return calender.date(byAdding: component, value: value, to: base)
    }

    /// 兼容旧版本：返回 base（不推荐，应优先使用 adding(_:value:isChain:)? 并处理 nil）
    public func addingOrNil(_ component: Calendar.Component, value: Int, isChain: Bool = true) -> Date? {
        return adding(component, value: value, isChain: isChain)
    }

    /// How many years ago.
    public func yearAgo(with value: Int) -> Date {
        // 修复：日期溢出时（如 -1年 跨越闰年边界）返回 base，避免强制解包崩溃
        return adding(.year, value: -value)?.fy.adding(.day, value: 1) ?? base
    }

    /// How many years later
    public func yearLater(with value: Int) -> Date {
        return adding(.year, value: value) ?? base
    }

    /// How many month ago.
    public func monthAgo(with value: Int) -> Date {
        return adding(.month, value: -value)?.fy.adding(.day, value: 1) ?? base
    }

    /// How many month later
    public func monthLater(with value: Int) -> Date {
        return adding(.month, value: value) ?? base
    }

    public func aWeekAgo() -> Date {
        return adding(.day, value: -6) ?? base
    }
    
    /// The start date of the current month.
    public func startOfMonth() -> Date {
        let calendar = Date.fy.localCalender
        let components = calendar.dateComponents(Set<Calendar.Component>([.year, .month]), from: base)
        guard let startOfMonth = calendar.date(from: components) else {
            return base
        }
        return startOfMonth
    }
    
    /// The end date of the current month.
    public func endOfMonth() -> Date {
        let calendar = Date.fy.localCalender//NSCalendar.current
        var components = DateComponents()
        components.month = 1
        components.second = -1
        let date = startOfMonth()
        guard let endOfMonth = calendar.date(byAdding: components, to: date) else {
            return base
        }
        return endOfMonth
    }
    
    public var year: Int {
        get {
            return Date.fy.calendar.component(.year, from: base)
        }
        set {
            guard newValue > 0 else { return }
            let currentYear = Date.fy.calendar.component(.year, from: base)
            let yearsToAdd = newValue - currentYear
            if let date = Date.fy.calendar.date(byAdding: .year, value: yearsToAdd, to: base) {
                self = BoxWrapper.init(date)
            }
        }
    }
    
    public var month: Int {
        get {
            return Date.fy.calendar.component(.month, from: base)
        }
        set {
            // 修复：range(of:in:for:) 在某些日历（如 custom 日历）下可能返回 nil，
            // 强制解包会崩溃；改为 guard let
            guard let allowedRange = Date.fy.calendar.range(of: .month, in: .year, for: base),
                  allowedRange.contains(newValue) else { return }
            let currentMonth = Date.fy.calendar.component(.month, from: base)
            let monthsToAdd = newValue - currentMonth
            if let date = Date.fy.calendar.date(byAdding: .month, value: monthsToAdd, to: base) {
                self = BoxWrapper.init(date)
            }
        }
    }

    public var day: Int {
        get {
            return Date.fy.calendar.component(.day, from: base)
        }
        set {
            // 修复：同上，range(of:in:for:) 可能返回 nil
            guard let allowedRange = Date.fy.calendar.range(of: .day, in: .month, for: base),
                  allowedRange.contains(newValue) else { return }
            let currentDay = Date.fy.calendar.component(.day, from: base)
            let daysToAdd = newValue - currentDay
            if let date = Date.fy.calendar.date(byAdding: .day, value: daysToAdd, to: base) {
                self = BoxWrapper.init(date)
            }
        }
    }
}
