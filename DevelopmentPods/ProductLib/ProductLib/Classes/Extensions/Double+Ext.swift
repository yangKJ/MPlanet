//
//  Double+Ext.swift
//  Cabinets
//
//  Created by Condy on 2023/4/28.
//

import Foundation

extension BoxWrapper where Double == Base {
    
    public var addTopSafeArea: Double {
        let safeAreaHeight: CGFloat
        if #available(iOS 11.0, *) {
            safeAreaHeight = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0.0
        } else {
            safeAreaHeight = 0.0
        }
        return Double(safeAreaHeight) + base
    }
    
    public var addBottomSafeArea: Double {
        let safeAreaHeight: CGFloat
        if #available(iOS 11.0, *) {
            safeAreaHeight = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0.0
        } else {
            safeAreaHeight = 0.0
        }
        return Double(safeAreaHeight) + base
    }
}

extension BoxWrapper where Base == Double {
    
    public func decimal() -> NSDecimalNumber {
        return NSDecimalNumber(value: base)
    }
    
    public func rateString() -> String {
        return base.fy.string(minPrecision: 2, maxPrecision: 5)
    }
    
    public func minPointString() -> String {
        return base.fy.string(minPrecision: 0, maxPrecision: 5)
    }
    
    public func decimalString(precision: Int = 2) -> String {
        return NSDecimalNumber(value: base).fy.decimalString(precision: precision)
    }
    
    public func string(minPrecision: Int = 2, maxPrecision: Int = 2) -> String {
        let string = String(describing: base)
        let array = string.components(separatedBy: ".") // fix bug: 8372.18 精度丢失（iOS 14）
        if array.count == 2 && (array.last?.count ?? 0) <= 2 {
            return NSDecimalNumber(string: string).fy.string(minPrecision: minPrecision, maxPrecision: maxPrecision)
        }
        return NSDecimalNumber(value: base).fy.string(minPrecision: minPrecision, maxPrecision: maxPrecision)
    }
}
