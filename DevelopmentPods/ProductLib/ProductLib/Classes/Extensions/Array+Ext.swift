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
    
    /// 移动索引元素
    public mutating func move(_ index: Int, toIndex: Int? = nil) {
        guard self.indices.contains(index) else {
            return
        }
        let element = self[index]
        remove(at: index)
        if let toIndex = toIndex, toIndex < self.count - 1 {
            insert(element, at: toIndex)
        } else {
            append(element)
        }
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
    public func frist(where predicate: (Element) throws -> Bool) rethrows -> (Element?, index: Int) {
        for (index, element) in enumerated() where try predicate(element) {
            return (element, index)
        }
        return (nil, 0)
    }
    
    /// 替换数据，有则替换，无则插入在最后
    /// - Parameters:
    ///   - predicate: 筛选条件
    ///   - object: 待替换对象
    ///   - replaceAll: 是否替换全部
    /// - Returns: 替换之后的数组
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

extension Array where Element: Equatable {
    
    public mutating func removeFirst(_ element: Element) {
        if let index = firstIndex(of: element) {
            remove(at: index)
        }
    }
    
    public mutating func removeLast(_ element: Element) {
        if let index = lastIndex(of: element) {
            remove(at: index)
        }
    }
}

extension Array where Element: Hashable {
    
    /// 去重复
    public var unique: [Element] {
        var seen: Set<Element> = []
        return filter { seen.insert($0).inserted }
    }
}
