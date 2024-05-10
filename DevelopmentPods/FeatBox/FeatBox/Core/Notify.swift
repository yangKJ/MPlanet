//
//  Notify.swift
//  FeatBox
//
//  Created by Condy on 2024/5/10.
//

import Foundation

/// 所有通知相关<必须>
public struct Notify {
    public struct Login {
        public static let didLogin = Notification.Name("didLogin")
        public static let didLogout = Notification.Name("didLogout")
        public static let shouldLogoutAndClearToken = Notification.Name("shouldLogoutAndClearToken")
    }
    
    public struct UI {
        public static let fontChanged = Notification.Name("fontChanged")
        public static let themeChanged = Notification.Name("themeChanged")
    }
}
