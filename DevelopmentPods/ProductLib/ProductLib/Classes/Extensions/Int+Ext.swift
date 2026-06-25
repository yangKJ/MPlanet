//
//  Int+Ext.swift
//  ProductLib
//
//  Created by Condy on 2024/5/20.
//

import Foundation

extension BoxWrapper where Base == Int {
    
    public static func random(from: UInt32, to: UInt32) -> UInt32 {
        return (arc4random() % (to - from + 1)) + from
    }
    
    public func decimal() -> NSDecimalNumber {
        return NSDecimalNumber(value: base)
    }
}
