//
//  ExNumberType.swift
//  FeatBox
//
//  Created by Condy on 2020/11/23.
//

import Foundation

extension Bool {
    public func toInt() -> Int {
        return (self == true) ? 1 : 0
    }
    
    public func toCGFloat() -> CGFloat {
        return toInt().toCGFloat()
    }
    
    public func toDouble() -> Double {
        return toInt().toDouble()
    }
    
    public func toString() -> String {
        return (self == true) ? "true" : "false"
    }
}

extension Int {
    public func toBool() -> Bool {
        return self != 0
    }
    
    public func toCGFloat() -> CGFloat {
        return CGFloat(self)
    }
    
    public func toDouble() -> Double {
        return Double(self)
    }
    
    public func toString() -> String {
        return String(self)
    }
}

extension CGFloat {
    public func toBool() -> Bool {
        return self != 0
    }
    
    public func toInt() -> Int {
        return Int(self)
    }
    
    public func toDouble() -> Double {
        return Double(self)
    }
    
    public func toString() -> String {
        return String(self.toDouble())
    }
}

extension Double {
    public func toBool() -> Bool {
        return self != 0
    }
    
    public func toCGFloat() -> CGFloat {
        return CGFloat(self)
    }
    
    public func toInt() -> Int {
        return Int(self)
    }
    
    public func toString() -> String {
        return String(self)
    }
}

extension String {
    public func toBool() -> Bool {
        return toDouble().toBool()
    }
    
    public func toInt() -> Int {
        return Int(self) ?? 0
    }
    
    public func toDouble() -> Double {
        return Double(self) ?? 0
    }
    
    public func toCGFloat() -> CGFloat {
        return CGFloat(self.toDouble())
    }
}
