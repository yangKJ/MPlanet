//
//  MTTextField.swift
//  FeatBox
//
//  Created by Condy on 2020/10/22.
//

import Foundation
import UIKit

// See: https://github.com/wangyutao0424/MTTextField

open class MTTextField: UITextField {
    /// Format textfield type
    ///
    /// - card: separate for four unit, and limited 19 count
    /// - phone: separate for 3,4,4, and lmited 11 count
    /// - custom: you can custom type use calss Separator
    public enum MTFormat {
        case card
        case phone
        case custom(separtor: Separator)
    }
    
    lazy var manager: MTTextFieldManager = {
        let manager = MTTextFieldManager(textField: self)
        manager.enabeled = true
        return manager
    }()
    
    public init(frame: CGRect, type: MTFormat) {
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

final class MTTextFieldManager {
    
    private let digitals: [Character] = ["0","1","2","3","4","5","6","7","8","9"]
    
    private unowned let textField: UITextField
    
    fileprivate var enabeled: Bool = false
    fileprivate var separator: Separator = .card
    
    fileprivate var type: MTTextField.MTFormat = .card {
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
