//
//  Datasourceable.swift
//  Extensions
//
//  Created by Condy on 2023/5/31.
//

import Foundation
import HandyJSON

/// 数据源
public protocol Datasourceable {
    var datasource: HandyJSON? { get set }
}
