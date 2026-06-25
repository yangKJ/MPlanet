//
//  Date+Fixed.swift
//  ProductLib
//
//  Created by Condy on 2023/10/8.
//

import Foundation

extension BoxWrapper where Base == Date {
    
    /// Set server time date.
    public static func set(serverDate: Date?) {
        DateExtension.serverDate = serverDate
        DateExtension.systemUpTime = systemUpTime()
    }
    
    /// Current time, used instead of `Date()`.
    public static func fixed() -> Date {
        guard let date = DateExtension.serverDate else {
            return Date()
        }
        let time = systemUpTime()
        if time == 0 {
            return Date()
        }
        return date.addingTimeInterval(time - DateExtension.systemUpTime)
    }
    
    private struct DateExtension {
        static fileprivate var serverDate: Date?
        static fileprivate var systemUpTime: TimeInterval = 0
    }
    
    private static func systemUpTime() -> TimeInterval {
        var currentTime = time_t()
        time(&currentTime)
        var bootTime = timeval()
        var mib = [CTL_KERN, KERN_BOOTTIME]
        
        // NOTE: Use strideof(), NOT sizeof() to account for data structure
        // alignment (padding)
        // http://stackoverflow.com/a/27640066
        // https://devforums.apple.com/message/1086617#1086617
        var size = MemoryLayout<timeval>.stride
        
        let result = sysctl(&mib, u_int(mib.count), &bootTime, &size, nil, 0)
        
        if result == 0 {
            return TimeInterval(currentTime - bootTime.tv_sec)
        }
        return 0
    }
}
