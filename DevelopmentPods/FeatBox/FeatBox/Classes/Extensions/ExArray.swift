//
//  ExArray.swift
//  FeatBox
//
//  Created by Condy on 2020/11/23.
//

import Foundation

extension Array {
    /// 随机返回数组中的一个元素
    public func randomElement() -> Element? {
        if isEmpty { return nil }
        return self[Index(arc4random_uniform(UInt32(count)))]
    }
    
    /// “累加，和 reduce 类似，不过是将所有元素合并到一个数组中，并保留合并时每一步的值。”
    public func accumulate<Result>(_ initialResult: Result,
                                   _ nextPartialResult: (Result, Element) throws -> Result) rethrows -> [Result] {
        var accumulator = initialResult
        return try map {
            accumulator = try nextPartialResult(accumulator, $0)
            return accumulator
        }
    }
    
    /// “测试序列中是不是所有元素都满足某个标准”
    public func all(matching predicate: (Element) throws -> Bool) rethrows -> Bool {
        // 对于一个条件，如果没有元素不满足它的话，那意味着所有元素都满足它：
        return try !contains { try !predicate($0) }
    }
    
    /// “测试序列中是不是没有任何元素满足某个标准”
    public func none(matching predicate: (Element) throws -> Bool) rethrows -> Bool {
        return try !contains { try predicate($0) }
    }
    
    /// “计算满足条件的元素的个数，和 filter 相似，但是不会构建数组。”
    public func count(where predicate: (Element) throws -> Bool) rethrows -> Int {
        var count = 0
        for element in self where try predicate(element) {
            count += 1
        }
        return count;
    }
    
    /// “返回一个包含满足某个标准的所有元素的索引的列表，和 index(where:) 类似，但是不会在遇到首个元素时就停止。”
    public func indices(where predicate: (Element) throws ->Bool) rethrows -> [Int] {
        var indices = [Int]()
        for (index, element) in enumerated() where try predicate(element) {
            indices.append(index)
        }
        return indices
    }
    
    /// “在一个逆序数组中寻找第一个满足特定条件的元素”
    public func last(where predicate: (Element) throws ->Bool) rethrows -> Element? {
        for element in reversed() where try predicate(element) {
            return element
        }
        return nil
    }
}
