//
//  ExNumberType.swift
//  FeatBox
//
//  Created by Condy on 2020/11/23.
//

import Foundation

extension BoxWrapper where Base == Bool {
    
    public func toInt() -> Int {
        return (base == true) ? 1 : 0
    }
    
    public func toCGFloat() -> CGFloat {
        return toInt().ao.toCGFloat()
    }
    
    public func toDouble() -> Double {
        return toInt().ao.toDouble()
    }
    
    public func toString() -> String {
        return (base == true) ? "true" : "false"
    }
}

extension BoxWrapper where Base == Int {
    
    public func toBool() -> Bool {
        return base != 0
    }
    
    public func toCGFloat() -> CGFloat {
        return CGFloat(base)
    }
    
    public func toDouble() -> Double {
        return Double(base)
    }
    
    public func toString() -> String {
        return String(base)
    }
}

extension BoxWrapper where Base == CGFloat {
    
    public func toBool() -> Bool {
        return base != 0
    }
    
    public func toInt() -> Int {
        return Int(base)
    }
    
    public func toDouble() -> Double {
        return Double(base)
    }
    
    public func toString() -> String {
        return String(toDouble())
    }
}

extension BoxWrapper where Base == Double {
    
    public func toBool() -> Bool {
        return base != 0
    }
    
    public func toCGFloat() -> CGFloat {
        return CGFloat(base)
    }
    
    public func toInt() -> Int {
        return Int(base)
    }
    
    public func toString() -> String {
        return String(base)
    }
}

extension BoxWrapper where Base == String {
    
    public func toBool() -> Bool {
        return toDouble().ao.toBool()
    }
    
    public func toInt() -> Int {
        return Int(base) ?? 0
    }
    
    public func toDouble() -> Double {
        return Double(base) ?? 0
    }
    
    public func toCGFloat() -> CGFloat {
        return CGFloat(toDouble())
    }
}
