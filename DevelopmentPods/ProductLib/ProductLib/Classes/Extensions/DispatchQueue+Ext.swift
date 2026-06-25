//
//  DispatchQueue+Ext.swift
//  ProductLib
//
//  Created by Condy on 2025/3/6.
//

import Foundation

extension BoxWrapper where Base: DispatchQueue {
    
    public func safeAsync(_ block: @escaping ()->()) {
        if base === DispatchQueue.main && Thread.isMainThread {
            block()
        } else {
            base.async { block() }
        }
    }
    
    public func safeSync(_ block: @escaping () -> ()) {
        if base === DispatchQueue.main && Thread.isMainThread {
            block()
        } else {
            base.sync { block() }
        }
    }
}
