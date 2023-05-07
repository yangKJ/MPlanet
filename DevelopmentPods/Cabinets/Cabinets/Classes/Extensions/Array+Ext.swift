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
    
    /// 测试序列中是不是所有元素都满足某个标准
    public func all(matching predicate: (Element) throws -> Bool) rethrows -> Bool {
        // 对于一个条件，如果没有元素不满足它的话，那意味着所有元素都满足它：
        return try !contains { try !predicate($0) }
    }
    
    /// 测试序列中是不是没有任何元素满足某个标准
    public func none(matching predicate: (Element) throws -> Bool) rethrows -> Bool {
        return try !contains { try predicate($0) }
    }
    
    /// 计算满足条件的元素的个数，和 filter 相似，但是不会构建数组
    public func count(where predicate: (Element) throws -> Bool) rethrows -> Int {
        var count = 0
        for element in self where try predicate(element) {
            count += 1
        }
        return count;
    }
    
    /// 返回一个包含满足某个标准的所有元素的索引的列表，和 index(where:) 类似，但是不会在遇到首个元素时就停止
    public func indices(where predicate: (Element) throws -> Bool) rethrows -> [Int] {
        var indices = [Int]()
        for (index, element) in enumerated() where try predicate(element) {
            indices.append(index)
        }
        return indices
    }
    
    /// 在一个逆序数组中寻找第一个满足特定条件的元素
    public func last(where predicate: (Element) throws -> Bool) rethrows -> Element? {
        for element in reversed() where try predicate(element) {
            return element
        }
        return nil
    }
    
    /// 筛选寻找到第一个指定类型数据
    public func bolting<T>(type: T.Type) -> T? {
        for element in self where element is T {
            return element as! T
        }
        return nil
    }
    
    /// 筛选出第一个指定数据
    public func boltingFristObject(where predicate: (Element) throws -> Bool) rethrows -> (Element?, index: Int) {
        for (index, element) in enumerated() where try predicate(element) {
            return (element, index)
        }
        return (nil, 0)
    }
    
    /// 替换数据，有则替换，无则插入在最后
    public func replace(where predicate: (Element) -> Bool, with object: Element, replaceAll: Bool = false) -> [Element] {
        var array = self
        var isInsert = true
        for (index, element) in enumerated() where predicate(element) {
            isInsert = false
            if replaceAll == false {
                array.remove(at: index)
                array.insert(element, at: index)
                return array
            }
            array.remove(at: index)
            array.insert(element, at: index)
        }
        if isInsert {
            array.append(object)
        }
        return array
    }
}
