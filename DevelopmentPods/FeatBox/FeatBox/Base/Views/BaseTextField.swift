//
//  BaseTextField.swift
//  FeatBox
//
//  Created by Condy on 2024/5/20.
//

import Foundation
import ProductLib

open class BaseTextField: UITextField {
    
    public enum TextFieldType {
        case `default`
        case chineseAndEnglish
        case decimal
        case email
        case phone
        case password
        case safeIDCard
        case onePINCode
    }
    
    public var isLimitedEditing = false
    
    public var isRareChar: Bool = false
    
    public var textFieldType: BaseTextField.TextFieldType = .default {
        didSet {
            if oldValue.limitLength >= 0 {
                limitLength = 0
            }
            setup()
        }
    }
    
    public var limitLength: Int = 0 {
        didSet {
            if textFieldType.limitLength >= 0 && limitLength != textFieldType.limitLength {
                limitLength = textFieldType.limitLength
            } else {
                self.limitByStringOrBytes(length: limitLength)
            }
        }
    }
    
    public var limitByBytes: Bool = false {
        didSet {
            self.limitByStringOrBytes(length: limitLength)
        }
    }
    
    public func limitByStringOrBytes(length: Int) {
        if limitByBytes {
            self.fy.limitByBytes(length: length)
        } else {
            self.fy.limitByString(length: length)
        }
    }
    
    public func setTextDidChangeBlock(textDidChangeBlock: ((BaseTextField) -> Void)?) {
        self.textDidChangeBlock = textDidChangeBlock
    }
    
    public func setTextFieldTapReturnBlock(textFieldTapReturnBlock: ((BaseTextField) -> Void)?) {
        self.textFieldTapReturnBlock = textFieldTapReturnBlock
    }
    
    public func setTextFieldShouldBeginEditingBlock(textFieldShouldBeginEditingBlock: ((BaseTextField) -> Bool)?) {
        self.textFieldShouldBeginEditingBlock = textFieldShouldBeginEditingBlock
    }
    
    public func setTextFieldShouldEndEditingBlock(textFieldShouldEndEditingBlock: ((BaseTextField) -> Bool)?) {
        self.textFieldShouldEndEditingBlock = textFieldShouldEndEditingBlock
    }
    
    public func set(placeholder: String?, color: UIColor = .fy.placeholder, font: UIFont = .fy.system_14) {
        let attribute = NSAttributedString(string: placeholder ?? "", attributes: [
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.font: font.fy.fixedFont
        ])
        self.attributedPlaceholder = attribute
    }
    
    public override var text: String? {
        didSet {
            if oldValue != text {
                self.textChanged(fromSet: true)
            }
        }
    }
    
    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if textFieldType.needSafeKeyboard || isRareChar {
            return false
        }
        // 只能粘贴
        if #available(iOS 15.0, *) {
            if action == #selector(UIResponderStandardEditActions.pasteAndMatchStyle(_:)) ||
                action == #selector(UIResponderStandardEditActions.pasteAndGo(_:)) ||
                action == #selector(UIResponderStandardEditActions.pasteAndSearch(_:)) {
                return super.canPerformAction(action, withSender: sender)
            }
        } else {
            // Fallback on earlier versions
        }
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return super.canPerformAction(action, withSender: sender)
        } else {
            return false
        }
    }
    
    public override var keyboardType: UIKeyboardType {
        didSet {
            if keyboardType != textFieldType.keyboardType {
                keyboardType = textFieldType.keyboardType
            }
        }
    }
    
    public override var isSecureTextEntry: Bool {
        didSet {
            if isSecureTextEntry != textFieldType.isSecureTextEntry {
                isSecureTextEntry = textFieldType.isSecureTextEntry
            } else {
                delegateHandler.isSecureTextEntry = isSecureTextEntry
            }
        }
    }
    
    private let delegateHandler = BaseTextFieldDelegateHandler()
    // why: closure-based observer token 必须 strong hold,
    // 若用 weak 持有,observer 会被立即释放为 nil,
    // 导致 deinit 中无法调用 removeObserver,token 永远残留在 NotificationCenter,
    // 引发 callback 触发到已 dealloc 的对象 (潜在 crash/内存泄漏)。
    private var observer: NSObjectProtocol?
    private var fontSize: CGFloat?
    private weak var originalFont: UIFont?
    private(set) var textDidChangeBlock: ((BaseTextField) -> Void)?
    private(set) var textFieldTapReturnBlock: ((BaseTextField) -> Void)?
    private(set) var textFieldShouldBeginEditingBlock: ((BaseTextField) -> Bool)?
    private(set) var textFieldShouldEndEditingBlock: ((BaseTextField) -> Bool)?

    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
        NotificationCenter.default.removeObserver(self)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.spellCheckingType = .no
        self.autocorrectionType = .no
        self.addObserver()
        self.setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.spellCheckingType = .no
        self.autocorrectionType = .no
        self.addObserver()
        self.setup()
    }
    
    private func setup() {
        delegateHandler.textFieldType = textFieldType
        keyboardType = textFieldType.keyboardType
        self.delegate = delegateHandler
        delegateHandler.textField = self
        isSecureTextEntry = textFieldType.isSecureTextEntry
        if textFieldType.limitLength >= 0 {
            limitLength = textFieldType.limitLength
        }
    }
    
    private func addObserver() {
        observer = NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: self, queue: nil) { [weak self] _ in
            self?.textChanged(fromSet: false)
        }
    }
    
    private func textChanged(fromSet: Bool) {
        if !self.fy.isPinyinInputing {
            self.limitByStringOrBytes(length: self.limitLength)
            textDidChangeBlock?(self)
//            let newFont = originFont?.rareFontIfNeed(text: text)
//            if newFont != font {
//                super.font = newFont
//                self.superview?.setNeedsLayout()
//                self.superview?.layoutIfNeeded()
//            }
        }
    }
}

fileprivate class BaseTextFieldDelegateHandler: NSObject, UITextFieldDelegate {
    
    var textFieldType: BaseTextField.TextFieldType = .default
    
    var isSecureTextEntry: Bool = false
    
    weak var textField: UITextField?
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let field = textField as? BaseTextField else {
            return true
        }
        return field.textFieldShouldBeginEditingBlock?(field) ?? true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let field = textField as? BaseTextField else {
            return false
        }
        field.textFieldTapReturnBlock?(field)
        return false
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let field = textField as? BaseTextField else {
            return true
        }
        return field.textFieldShouldEndEditingBlock?(field) ?? true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let textField = textField as? BaseTextField, textField.isLimitedEditing, textField.isFirstResponder, string.count > 0 {
            return false
        }
        guard let text = textField.text else {
            return true
        }
        guard let rangeS = Range(range, in: text) else {
            return false
        }
        var selectedIndex = range.location + string.fy.lengthWithRare
        if isSecureTextEntry {
            var strings = [String]()
            for _ in 0..<string.count {
                strings.append("*")
            }
            textField.text?.replaceSubrange(rangeS, with: strings.joined(separator: ""))
            let selectedPosit = textField.position(from: textField.beginningOfDocument, offset: selectedIndex) ?? textField.endOfDocument
            textField.selectedTextRange = textField.textRange(from: selectedPosit, to: selectedPosit)
            return false
        }
        switch textFieldType {
        case .default:
            guard let newText = textField.text?.replacingCharacters(in: rangeS, with: string) else {
                return true
            }
            if !newText.fy.containsEmoji && !newText.fy.containsFullWidth {
                return true
            } else {
                selectedIndex = range.location + (string.isEmpty ? range.length : 0)
            }
        case .chineseAndEnglish:
            guard let newText = textField.text?.replacingCharacters(in: rangeS, with: string) else {
                return true
            }
            if !newText.fy.containsEmoji && !newText.fy.containEnglishSpecialChar && !newText.fy.containsFullWidth {
                return true
            } else {
                selectedIndex = range.location + (string.isEmpty ? range.length : 0)
            }
        case .email:
            if let newText = textField.text?.replacingCharacters(in: rangeS, with: string),
               newText.count == 0 || newText.fy.isValidInputingEmail {
                textField.text = newText
            } else {
                selectedIndex = range.location + (string.isEmpty ? range.length : 0)
            }
        case .decimal:
            if let newText = textField.text?.replacingCharacters(in: rangeS, with: string),
               newText.count == 0 || (newText.fy.isValidDecimal && (newText.fy.decimal() ?? 0.fy.decimal()) <= 10000000000000.00) {
                textField.text = newText
            } else {
                selectedIndex = range.location + (string.isEmpty ? range.length : 0)
            }
        case .phone:
            if let newText = textField.text?.replacingCharacters(in: rangeS, with: string),
               newText.count == 0 || (newText.count <= 11 && newText.fy.slicing(from: 0, length: 1) == "1" && newText.fy.isValidNumber) {
                textField.text = newText
            } else {
                selectedIndex = range.location + (string.isEmpty ? range.length : 0)
            }
        case .password:
            textField.text?.replaceSubrange(rangeS, with: string)
        case .onePINCode:
            textField.text?.replaceSubrange(rangeS, with: string)
        case .safeIDCard:
            textField.text?.replaceSubrange(rangeS, with: string)
        }
        // this is to fix a bug: selectedPosit is not correct
        let block = {
            let selectedPosit = (selectedIndex == (textField.text?.fy.lengthWithRare ?? 0)) ? textField.endOfDocument : (textField.position(from: textField.beginningOfDocument, offset: selectedIndex) ?? textField.endOfDocument)
            let textRange = textField.textRange(from: selectedPosit, to: selectedPosit)
            if textRange != textField.selectedTextRange {
                textField.selectedTextRange = textRange
            }
        }
        if string.count > 1 {
            DispatchQueue.main.async(execute: block)
        } else {
            block()
        }
        return false
    }
}


extension BaseTextField.TextFieldType {
    var keyboardType: UIKeyboardType {
        switch self {
        case .default:
            return .default
        case .chineseAndEnglish:
            return .default
        case .decimal:
            return .decimalPad
        case .email:
            return .emailAddress
        case .phone:
            return .numberPad
        case .password:
            return .asciiCapable
        case .safeIDCard:
            return .asciiCapable
        case .onePINCode:
            return .numberPad
        }
    }
    
    // 大于或等于0：由textFieldType控制长度，textField的长度限制无效
    // 小于0：由textField的长度限制进行控制
    var limitLength: Int {
        switch self {
        case .decimal:
            return 18
        case .onePINCode:
            return 1
        default:
            return -1
        }
    }
    
    var isSecureTextEntry: Bool {
        switch self {
        case .password, .onePINCode:
            return true
        default:
            return false
        }
    }
    
    var needSafeKeyboard: Bool {
        return (isSecureTextEntry && self != .onePINCode) || self == .safeIDCard
    }
    
    var isNumberOnly: Bool {
        switch self {
        case .phone, .onePINCode:
            return true
        default:
            return false
        }
    }
}
