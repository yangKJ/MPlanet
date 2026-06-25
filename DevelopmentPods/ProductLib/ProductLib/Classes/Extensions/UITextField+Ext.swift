//
//  UITextField+Ext.swift
//  ProductLib
//
//  Created by Condy on 2024/5/20.
//

import Foundation

extension BoxWrapper where Base: UITextField {
    
    public var isPinyinInputing: Bool {
        if UIApplication.shared.textInputMode?.primaryLanguage == "zh-Hans",
           let markedTextRange = self.base.markedTextRange,
           let _ = self.base.position(from: markedTextRange.start, offset: 0) {
            return true
        }
        return false
    }
    
    public var selectedRange: NSRange? {
        guard let textRange = self.base.selectedTextRange else {
            return nil
        }
        let location = base.offset(from: base.beginningOfDocument, to: textRange.start)
        let length = base.offset(from: textRange.start, to: textRange.end)
        return NSMakeRange(location, length)
    }
    
    public func limitByString(length: Int) {
        let text = length <= 0 ? self.base.text : self.base.text?.fy.substringWithRare(to: length)
        if text != self.base.text {
            let position = self.base.selectedTextRange?.start ?? self.base.endOfDocument
            self.base.text =  text
            self.base.selectedTextRange = self.base.textRange(from: position, to: position)
        }
    }
    
    public func limitByBytes(length: Int) {
        let text = length <= 0 ? self.base.text : self.base.text?.fy.substringByBytes(to: length)
        if text != self.base.text {
            let position = self.base.selectedTextRange?.start ?? self.base.endOfDocument
            self.base.text =  text
            self.base.selectedTextRange = self.base.textRange(from: position, to: position)
        }
    }
}
