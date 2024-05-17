//
//  LoginAuthVerfication.swift
//  FeatBox
//
//  Created by Condy on 2023/8/30.
//

import Foundation
import ProductLib

/// 登陆验证，内部会主动拉起登陆控件
public final class LoginAuthVerfication: NSObject, AuthVerificationable {
    
    public typealias AuthElement = Void
    
    public var authVerificationPassedInfo: Void {
        ()
    }
    
    public func isAuthVerificationPassed() -> Bool {
        return Session.shared.loginState == .logged
    }
    
    public func authVerificationAction(authCompletion: AuthCompletion?, uiCompletion: AuthCompletion?, canceled: Canceled?) {
        if Session.shared.loginState == .logging {
            UIWindow.fy.keyWindow()?.fy.showHUD(title: Res.text("正在登录中，请稍后"))
            return
        }
        // 登陆处理...
        Session.shared.loginState = .logging
        let vc = UIViewController.fy.currentViewController()
        vc?.view.fy.showHUD(title: Res.text("模拟登陆ing.."), afterDelay: 3)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            var userDTO = UserDTO()
            userDTO.token = "PH00278922k35C77"
            userDTO.hasPrivilegeBarItem = "WALLET_TAB_BAR" // 模拟增加一个钱包TabBar
            userDTO.accountStatus = .normal
            Session.shared.loggedSuccess(userDTO)
            authCompletion?(())
            vc?.view.fy.hideHUD()
            uiCompletion?(())
        }
    }
}
