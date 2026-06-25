//
//  NSDecimalNumber+Ext.swift
//  FeatBox
//
//  Created by Condy on 2023/4/28.
//

import Foundation

extension NSDecimalNumber {
    public static func +(lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
        return lhs.adding(rhs)
    }
    
    public static func -(lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
        return lhs.subtracting(rhs)
    }
    
    public static func *(lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
        return lhs.multiplying(by: rhs)
    }
    
    public static func /(lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
        return lhs.dividing(by: rhs)
    }
    
    public static func +=(lhs: inout NSDecimalNumber, rhs: NSDecimalNumber) {
        lhs = lhs.adding(rhs)
    }
    
    public static func -=(lhs: inout NSDecimalNumber, rhs: NSDecimalNumber) {
        lhs = lhs.subtracting(rhs)
    }
    
    public static func <(lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> Bool {
        return lhs.compare(rhs) == .orderedAscending
    }
    
    public static func >(lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> Bool {
        return lhs.compare(rhs) == .orderedDescending
    }
    
    public static func <=(lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> Bool {
        return lhs.compare(rhs) != .orderedDescending
    }
    
    public static func >=(lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> Bool {
        return lhs.compare(rhs) != .orderedAscending
    }
    
    public static func ==(lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> Bool {
        return lhs.compare(rhs) == .orderedSame
    }
    
    public static func !=(lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> Bool {
        return lhs.compare(rhs) != .orderedSame
    }
    
    public static func <(lhs: NSDecimalNumber, rhs: Double) -> Bool {
        return lhs < NSDecimalNumber(value: rhs)
    }
    
    public static func >(lhs: NSDecimalNumber, rhs: Double) -> Bool {
        return lhs > NSDecimalNumber(value: rhs)
    }
    
    public static func <=(lhs: NSDecimalNumber, rhs: Double) -> Bool {
        return lhs <= NSDecimalNumber(value: rhs)
    }
    
    public static func >=(lhs: NSDecimalNumber, rhs: Double) -> Bool {
        return lhs >= NSDecimalNumber(value: rhs)
    }
    
    public static func ==(lhs: NSDecimalNumber, rhs: Double) -> Bool {
        return lhs == NSDecimalNumber(value: rhs)
    }
    
    public static func !=(lhs: NSDecimalNumber, rhs: Double) -> Bool {
        return lhs != NSDecimalNumber(value: rhs)
    }
    
    public static func <(lhs: NSDecimalNumber, rhs: Int) -> Bool {
        return lhs < NSDecimalNumber(value: rhs)
    }
    
    public static func >(lhs: NSDecimalNumber, rhs: Int) -> Bool {
        return lhs > NSDecimalNumber(value: rhs)
    }
    
    public static func <=(lhs: NSDecimalNumber, rhs: Int) -> Bool {
        return lhs <= NSDecimalNumber(value: rhs)
    }
    
    public static func >=(lhs: NSDecimalNumber, rhs: Int) -> Bool {
        return lhs >= NSDecimalNumber(value: rhs)
    }
    
    public static func ==(lhs: NSDecimalNumber, rhs: Int) -> Bool {
        return lhs == NSDecimalNumber(value: rhs)
    }
    
    public static func !=(lhs: NSDecimalNumber, rhs: Int) -> Bool {
        return lhs != NSDecimalNumber(value: rhs)
    }
}

extension BoxWrapper where Base: NSDecimalNumber {
    
    public func max(_ value: NSDecimalNumber) -> NSDecimalNumber {
        value.compare(self.base) == .orderedDescending ? value : self.base
    }
    
    public func min(_ value: NSDecimalNumber) -> NSDecimalNumber {
        value.compare(self.base) == .orderedAscending ? value : self.base
    }
    
    public func abs() -> NSDecimalNumber {
        let zero = 0.fy.decimal()
        if self.base.compare(zero) != .orderedAscending {
            return self.base
        } else {
            return zero.subtracting(self.base)
        }
    }
    
    public func roundDown() -> NSDecimalNumber {
        let handler = NSDecimalNumber.fy.handler(roundingMode: .down, scale: 0)
        return self.base.rounding(accordingToBehavior: handler)
    }
    
    public func roundUp() -> NSDecimalNumber {
        let handler = NSDecimalNumber.fy.handler(roundingMode: .up, scale: 0)
        return self.base.rounding(accordingToBehavior: handler)
    }
    
    public func string(minPrecision: Int = 2, maxPrecision: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "zh-Hans")
        formatter.numberStyle = .none
        formatter.minimumIntegerDigits = 1
        formatter.maximumFractionDigits = maxPrecision
        formatter.minimumFractionDigits = minPrecision
        let handler = NSDecimalNumber.fy.handler(roundingMode: .plain, scale: Int16(maxPrecision))
        return formatter.string(from: base.rounding(accordingToBehavior: handler)) ?? ""
    }
    
    /// 带千分符号的字符串
    public func decimalString(precision: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "zh-Hans")
        formatter.numberStyle = .decimal //千分符
        formatter.minimumIntegerDigits = 1
        formatter.maximumFractionDigits = precision
        formatter.minimumFractionDigits = precision
        let handler = NSDecimalNumber.fy.handler(roundingMode: .plain, scale: Int16(precision))
        return formatter.string(from: base.rounding(accordingToBehavior: handler)) ?? ""
    }
    
    private static func handler(roundingMode: NSDecimalNumber.RoundingMode, scale: Int16) -> NSDecimalNumberHandler {
        NSDecimalNumberHandler(roundingMode: roundingMode,
                               scale: scale,
                               raiseOnExactness: false,
                               raiseOnOverflow: false,
                               raiseOnUnderflow: false,
                               raiseOnDivideByZero: false)
    }
}
