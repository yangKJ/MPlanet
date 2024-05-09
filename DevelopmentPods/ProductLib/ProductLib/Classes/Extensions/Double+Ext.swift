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
    
    public func decimal() -> NSDecimalNumber {
        return NSDecimalNumber(value: base)
    }
}
