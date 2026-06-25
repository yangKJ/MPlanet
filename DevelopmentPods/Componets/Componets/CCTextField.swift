//
//  CCTextField.swift
//  FeatBox
//
//  Created by Condy on 2020/10/22.
//

import Foundation
import UIKit

// See: https://github.com/wangyutao0424/MTTextField
/// 自动分割输入框控件
open class CCTextField: UITextField {
    /// Format textfield type
    ///
    /// - card: separate for four unit, and limited 19 count
    /// - phone: separate for 3,4,4, and lmited 11 count
    /// - custom: you can custom type use calss Separator
    public enum Format {
        case card
        case phone
        case custom(separtor: Separator)
    }
    
    lazy var manager: TextFieldManager = {
        let manager = TextFieldManager(textField: self)
        manager.enabeled = true
        return manager
    }()
    
    public init(frame: CGRect, type: Format) {
        super.init(frame: frame)
        self.manager.type = type
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public var formatEnabled: Bool {
        get {
            return self.manager.enabeled
        }
        set {
            self.manager.enabeled = newValue
        }
    }
    
    public func setTextToFormat(text: String?) {
        if !self.manager.enabeled {
            self.text = text
            return
        }
        self.manager.setTextToFormate(text: text)
    }
    
    public func pureDigital() -> String {
        if self.manager.enabeled {
            return self.manager.pureDigital()
        }
        return self.text ?? ""
    }
}

final class TextFieldManager {
    
    private let digitals: [Character] = ["0","1","2","3","4","5","6","7","8","9"]
    
    private unowned let textField: UITextField
    
    fileprivate var enabeled: Bool = false
    fileprivate var separator: Separator = .card
    
    fileprivate var type: CCTextField.Format = .card {
        didSet {
            switch type {
            case .card:
                separator = .card
            case .phone:
                separator = .phone
            case .custom(let sep):
                separator = sep
            }
            _texFieldChanged(textField: self.textField)
        }
    }
    
    init(textField: UITextField) {
        self.textField = textField
        self.textField.addTarget(self, action: #selector(_texFieldChanged(textField:)), for: .editingChanged)
    }
    
    func setTextToFormate(text: String?) {
        self.textField.text = text
        _texFieldChanged(textField: self.textField)
    }
    
    @objc private func _texFieldChanged(textField: UITextField) {
        if !enabeled { return }
        var cursorPositon = 0
        if let startRange = textField.selectedTextRange?.start {
            cursorPositon = textField.offset(from: textField.beginningOfDocument, to: startRange)
        }
        let pureDigital = self.removeNotDigitals(text: textField.text, cursorPosition: &cursorPositon)
        let spaceText = self.format(text: pureDigital, cursorPosition: &cursorPositon)
        textField.text = spaceText
        if let position = textField.position(from: textField.beginningOfDocument, offset: cursorPositon) {
            textField.selectedTextRange = textField.textRange(from: position, to: position)
        }
    }
    
    func removeNotDigitals(text: String?, cursorPosition: inout Int) -> String {
        guard let str = text else { return "" }
        cursorPosition = max(cursorPosition, 0)
        
        let prefix = str.prefix(cursorPosition)
        let preDig = self.pureNumber(text: String(prefix))
        let strDig = self.pureNumber(text: str)
        cursorPosition = preDig.count
        return strDig
    }
    
    func format(text: String?, cursorPosition: inout Int) -> String {
        guard let str = text else { return "" }
        cursorPosition = max(cursorPosition, 0)
        let originCursor = cursorPosition
        var count = 0
        var value = [Character]()
        separator.reset()
        for c in str {
            if count >= separator.maxCount {
                break
            }
            if count > 0, let grid = separator.currentGrid(), count == grid {
                value.append(" ")
                if count < originCursor, count != originCursor  {
                    cursorPosition += 1
                }
                separator.next()
            }
            value.append(c)
            count += 1
        }
        return String(value)
    }
    
    func pureDigital() -> String {
        return self.pureNumber(text: textField.text)
    }
    
    func pureNumber(text: String?) -> String {
        guard let str = text else { return "" }
        var value = [Character]()
        for c in str {
            if digitals.contains(c) {
                value.append(c)
            }
        }
        return String(value)
    }
}

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
