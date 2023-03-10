//
//  ExBool.swift
//  FeatBox
//
//  Created by Condy on 2020/11/23.
//

import Foundation

public extension Bool {
    public func toggle() -> Bool {
        return !self
    }
    public mutating func toggled() {
        self = !self
    }
}
