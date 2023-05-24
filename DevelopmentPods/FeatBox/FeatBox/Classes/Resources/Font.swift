//
//  Font.swift
//  FeatBox
//
//  Created by Condy on 2023/5/24.
//

import Foundation
import Contacts

/// 添加 `ai` 前缀，字体必须走这块方便后续做修改字体大小
public extension BoxWrapper where Base: UIFont {
    
    static var bold_18: UIFont {
        UIFont.ai.boldSystemFont(ofSize: 18)
    }
    
    static var system_20: UIFont {
        UIFont.ai.systemFont(ofSize: 20)
    }
    
    static var system_18: UIFont {
        UIFont.ai.systemFont(ofSize: 18)
    }
    
    static var system_14: UIFont {
        UIFont.ai.systemFont(ofSize: 14)
    }
}
