//
//  Character+Ext.swift
//  FeatBox
//
//  Created by Condy on 2024/5/20.
//

import Foundation

extension BoxWrapper where Base == Character {
    
    public var isRareChar: Bool {
        for scalar in base.unicodeScalars {
            switch scalar.value {
            case 0x3400...0x4DB5,
                0x20000...0x2A6D6,
                0x2A700...0x2B734,
                0x2B740...0x2B81D,
                0x2B820...0x2CEAF,
                0x2CEB0...0x2EBE0,
                0x30000...0x3134A,
                0x9FA6...0x9FFF,
                0x4DB6...0x4DBF,
                0x2A6D7...0x2A6DF,
                0xE000...0xF8FF,
                0xF900...0xFAFF,
                0x2F800...0x2FA1D,
                0x31350...0x323AF,
                0x2F00...0x2FD5,
                0x2E80...0x2EF3,
                0x31C0...0x31E3,
                0x2FF0...0x2FFB,
                0x3105...0x312F,
                0x31A0...0x31BF,
                0x3007:
                return true
            default:
                continue
            }
        }
        return false
    }
}
