//
//  ExString.swift
//  FeatBox
//
//  Created by Condy on 2020/11/23.
//

import Foundation

extension BoxWrapper where Base == String {
    
    public var isBlank: Bool {
        let blanks = [
            "NIL", "Nil", "nil", "NULL", "Null", "null", "(NULL)", "(Null)", "(null)", "<NULL>", "<Null>", "<null>"
        ]
        return base.isEmpty || base.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty || blanks.contains(base)
    }
    
    public var isNotBlank: Bool {
        return !isBlank
    }
    
    public var trimmed: String {
        return base.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
