//
//  Notify.swift
//  FeatBox
//
//  Created by Condy on 2024/5/10.
//

import Foundation

/// 所有通知相关<必须>，这边采用枚举来设计，避免通知名拼写错误
public struct Notify {
    
    public enum Login: String, NotifyEventable {
        case didLogin
        case didLogout
        case shouldLogoutAndClearToken
    }
    
    public enum UI: String, NotifyEventable {
        case fontChanged
        case themeChanged
        case launchScrollViewChanged
    }
}
