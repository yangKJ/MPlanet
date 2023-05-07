//
//  TimeInterval+Ext.swift
//  FeatBox
//
//  Created by Condy on 2023/4/28.
//

import Foundation

extension BoxWrapper where Base == TimeInterval {
    
    /// 转换毫秒日期
    public var millisecondDate: Date {
        Date(timeIntervalSince1970: base / 1000.0)
    }
}
