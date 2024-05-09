//
//  Others.swift
//  ImageX
//
//  Created by Condy on 2023/6/29.
//

import Foundation

// 特殊参数
struct Others {
    
    typealias Key = String
    
    let key: Key
    
    let value: Any?
}

extension Others {
    /// UIButton setting status `UIControl.State` pass as a parameter.
    enum UIButtonKey: Others.Key {
        case image = "ButtonKeyImage"
        case backgroundImage = "ButtonKeyBackgroundImage"
    }
    
    enum NSButtonKey: Others.Key {
        case image = "NSButtonKeyImage"
        case alternateImage = "NSButtonKeyAlternateImage"
    }
    
    enum UIImageViewKey: Others.Key {
        case image = "UIImageViewKeyImage"
        case highlightedImage = "UIImageViewKeyHighlightedImage"
    }
    
    enum NSTextAttachmentKey: Others.Key {
        case image = "NSTextAttachmentKeyImage"
    }
}
