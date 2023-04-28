//
//  NSDecimalNumber+Ext.swift
//  FeatBox
//
//  Created by Condy on 2023/4/28.
//

import Foundation

extension BoxWrapper where Base: NSDecimalNumber {
    
    public func decimalString(precision: Int = 2) -> String {
        string(minPrecision: precision, maxPrecision: precision)
    }
    
    public func string(minPrecision: Int = 2, maxPrecision: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "zh-Hans")
        formatter.numberStyle = .none
        formatter.minimumIntegerDigits = 1
        formatter.maximumFractionDigits = maxPrecision
        formatter.minimumFractionDigits = minPrecision
        let rounding = NSDecimalNumberHandler(roundingMode: .bankers,
                                              scale: Int16(maxPrecision),
                                              raiseOnExactness: false,
                                              raiseOnOverflow: false,
                                              raiseOnUnderflow: false,
                                              raiseOnDivideByZero: false)
        return formatter.string(from: base.rounding(accordingToBehavior: rounding)) ?? ""
    }
}
