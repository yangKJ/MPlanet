//
//  Container.swift
//  FeatBox
//
//  Created by Condy on 2021/1/5.
//

import Foundation

public protocol Container {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

extension Container where Item == Double {
    public func average() -> Double {
        var sum = 0.0
        for index in 0..<count {
            sum += self[index]
        }
        return sum / Double(count)
    }
}
