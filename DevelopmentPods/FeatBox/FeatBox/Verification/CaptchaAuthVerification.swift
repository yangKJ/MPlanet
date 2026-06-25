//
//  CaptchaAuthVerification.swift
//  FeatBox
//
//  Created by Condy on 2024/5/20.
//

import Foundation

/// 短信验证类型
public struct CaptchaSMSType {
    let rawValue: String
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

/// 短信验证，内部封装短信组件
public final class CaptchaAuthVerification: NSObject, AuthVerificationable {
    
    public struct AuthResult {
        public let mobile: String? //手机号
        public let serialNumber: String? //短信流水号
        public let captchaViewController: UIViewController?
    }
    
    public typealias AuthElement = AuthResult?
    
    public var authVerificationPassedInfo: AuthResult? {
        nil
    }
    
    public func isAuthVerificationPassed() -> Bool {
        return false
    }
    
    private let smsType: CaptchaSMSType
    private let mobile: String?
    
    /// 初始化
    /// - Parameters:
    ///   - smsType: 短信验证类型
    ///   - mobile: 手机号，不传则是去获取预留手机号
    init(smsType: CaptchaSMSType, mobile: String? = nil) {
        self.smsType = smsType
        self.mobile = mobile
    }
    
    public func authVerificationAction(authCompletion: AuthCompletion?, uiCompletion: AuthCompletion?, canceled: Canceled?) {
        // 死代码修复：原实现空函数导致 UI 静默卡住, 调用方永远不会收到任何回调。
        // 这里直接走 canceled 走错误流，业务方可以根据错误统一提示"短信验证未实现"。
        canceled?(CustomError.error(NSError(domain: "CaptchaAuthVerification",
                                            code: -1,
                                            userInfo: [NSLocalizedDescriptionKey: "Captcha auth not implemented"])))
    }
}
