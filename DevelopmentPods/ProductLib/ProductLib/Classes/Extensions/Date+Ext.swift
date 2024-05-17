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
    
    /// Date by adding multiples of calendar component.
    /// - Parameters:
    ///   - component: A single component to add.
    ///   - value: The value of the specified component to add.
    ///   - isChain: Is it China's time zone, 中国时区和大西洋时区有8小时时差
    /// - Returns: Original date + multiples of component added.
    public func adding(_ component: Calendar.Component, value: Int, isChain: Bool = true) -> Date {
        let calender = isChain ? Date.fy.localCalender : Date.fy.calendar
        return calender.date(byAdding: component, value: value, to: base)!
    }
    
    /// How many years ago.
    public func yearAgo(with value: Int) -> Date {
        adding(.year, value: -value).fy.adding(.day, value: 1)
    }
    
    /// How many years later
    public func yearLater(with value: Int) -> Date {
        adding(.year, value: value)//.fy.adding(.day, value: 1)
    }
    
    /// How many month ago.
    public func monthAgo(with value: Int) -> Date {
        adding(.month, value: -value).fy.adding(.day, value: 1)
    }
    
    /// How many month later
    public func monthLater(with value: Int) -> Date {
        adding(.month, value: value)
    }
    
    public func aWeekAgo() -> Date {
        return adding(.day, value: -6)
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
}
