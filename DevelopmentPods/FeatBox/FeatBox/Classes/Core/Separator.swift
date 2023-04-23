//
//  Separator.swift
//  FeatBox
//
//  Created by Condy on 2023/4/23.
//

import Foundation

protocol Separatorable {
    var maxCount: Int { get set }
    @discardableResult func next() -> Int?
    func currentGrid() -> Int?
    func reset()
}

public class Separator: Separatorable {
    static let card = GridSeparator(maxCount: 19, grid: 4)
    static let phone = GroupSeparator(maxCount: 11, group: [3, 4, 4])
    
    var maxCount: Int = 0
    
    @discardableResult func next() -> Int? {
        return nil
    }
    
    func currentGrid() -> Int? {
        return nil
    }
    
    func reset() { }
}

final class GridSeparator: Separator {
    private var grid: Int
    private var current: Int?
    
    public init(maxCount: Int, grid: Int) {
        self.grid = grid
        super.init()
        self.maxCount = maxCount
        reset()
    }
    
    override func next() -> Int? {
        if grid < 1 {
            current = nil
            return current
        }
        current = (current ?? 0) + grid
        return current
    }
    
    override func currentGrid() -> Int? {
        return current
    }
    
    override func reset() {
        current = grid > 0 ? grid : nil
    }
}

final class GroupSeparator: Separator {
    private var group: [Int]
    private var current: Int?
    private var currentIndex: Int = 0
    
    init(maxCount: Int, group: [Int]) {
        self.group = group.filter({ $0 > 0 })
        super.init()
        self.maxCount = maxCount
        reset()
    }
    
    override func next() -> Int? {
        currentIndex = currentIndex + 1
        guard group.count > currentIndex else {
            current = nil
            return current
        }
        let count = group[currentIndex]
        if maxCount > count {
            current = count + (current ?? 0)
        } else {
            current = nil
        }
        return current
    }
    
    override func currentGrid() -> Int? {
        return current
    }
    
    override func reset() {
        current = nil
        currentIndex = 0
        guard group.count > 0 else {
            return
        }
        let count = group[currentIndex]
        if maxCount > count {
            current = count
        }
    }
}
