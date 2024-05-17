//
//  Session.swift
//  FeatBox
//
//  Created by Condy on 2023/8/30.
//

import Foundation
import UIKit

public class Session {
    
    public private(set) static var shared = Session()
    
    /// 登陆成功之后的用户数据
    public private(set) var loggedUserDTO: UserDTO?
    /// 退出登陆不会清空该数据
    public var token: String? {
        get { AppUserSettings.token }
    }
    
    public var loginState: Session.LoginState = .none {
        didSet {
            switch loginState {
            case .logged:
                if oldValue != .logged {
                    // 可发送登陆成功通知
                    NotificationCenter.default.post(name: Notify.Login.didLogin, object: nil)
                }
            case .none:
                if oldValue == .logged {
                    // 可发送退出登陆通知
                    NotificationCenter.default.post(name: Notify.Login.didLogout, object: nil)
                }
            case .logging:
                break
            }
        }
    }
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 登陆成功
    public func loggedSuccess(_ userDTO: UserDTO) {
        self.loggedUserDTO = userDTO
        AppUserSettings.token = userDTO.token
        self.loginState = .logged
    }
    
    /// 退出登陆
    public func logout() {
        self.loginState = .none
        self.loggedUserDTO = nil
    }
}

extension Session {
    public enum LoginState: Int {
        case none = 0
        case logged
        case logging
    }
}

extension Session {
    
    @objc private func didEnterBackground() {
        if loginState == .logged {
            
        }
    }
    
    @objc private func willEnterForeground() {
        if loginState == .logged {
            
        }
    }
}
