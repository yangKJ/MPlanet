//
//  Collection+Ext.swift
//  FeatBox
//
//  Created by Condy on 2022/4/25.
//

import Foundation

extension Collection {
    
    /// Safe protects the array from out of bounds by use of optional.
    public subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
