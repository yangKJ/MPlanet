//
//  DeviceAuthVerification.swift
//  FeatBox
//
//  Created by Condy on 2024/5/20.
//

import Foundation
import LocalAuthentication
import ProductLib

/// 指纹/面容验证
public final class DeviceAuthVerification: NSObject, AuthVerificationable {
    
    public struct AuthResult {
        public let authResult: DeviceAuthResult
        public var evaluatedPolicyDomainState: Data?
    }
    
    public typealias AuthElement = AuthResult?
    
    public var authVerificationPassedInfo: AuthResult? {
        nil
    }
    
    public func isAuthVerificationPassed() -> Bool {
        return false
    }
    
    private let deviceType: DeviceAuthVerification.DeviceType
    private let descContext = LAContext()
    private var fallbackTitle: String?
    private var authCompletion: AuthCompletion?
    private var uiCompletion: AuthCompletion?
    private var canceled: Canceled?
    
    public init(fallbackTitle: String?) {
        self.fallbackTitle = fallbackTitle
        if let fallbackTitle = fallbackTitle {
            self.descContext.localizedFallbackTitle = fallbackTitle
        }
        self.deviceType = DeviceType.init(descContext: descContext)
    }
    
    public static func biometricsSupported() -> Bool {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            return true
        }
        switch error?.code {
        case LAError.Code.touchIDNotAvailable.rawValue:
            return false
        case LAError.Code.touchIDNotEnrolled.rawValue:
            return true
        case LAError.Code.touchIDLockout.rawValue:
            return true
        case LAError.Code.passcodeNotSet.rawValue:
            return true
        default:
            return true
        }
    }
    
    public func authVerificationAction(authCompletion: AuthCompletion?, uiCompletion: AuthCompletion?, canceled: Canceled?) {
        self.authCompletion = authCompletion
        self.uiCompletion = uiCompletion
        self.canceled = canceled
        self.startWith(fallbackTitle: fallbackTitle)
    }
    
    private func startWith(fallbackTitle: String?) {
        if let fallbackTitle = fallbackTitle {
            descContext.localizedFallbackTitle = fallbackTitle
        }
        var supportPolicy: LAPolicy?
        var error: NSError?
        if descContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            supportPolicy = .deviceOwnerAuthenticationWithBiometrics
        } else if descContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
            if error?.code == LAError.Code.touchIDLockout.rawValue {
                supportPolicy = .deviceOwnerAuthentication
            }
        }
        guard let policy = supportPolicy else {
            switch error?.code {
            case LAError.Code.touchIDNotAvailable.rawValue:
                self.result(authResult: .notSupported, data: nil)
            case LAError.Code.touchIDNotEnrolled.rawValue:
                self.result(authResult: .notSet, data: nil)
            case LAError.Code.touchIDLockout.rawValue:
                self.result(authResult: .locked, data: nil)
            case LAError.Code.passcodeNotSet.rawValue:
                self.result(authResult: .notOpen, data: nil)
            default:
                self.result(authResult: .unknown, data: nil)
            }
            return
        }
        descContext.evaluatePolicy(policy, localizedReason: deviceType.reason) { [weak self] (success, error) in
            if success {
                if policy == .deviceOwnerAuthenticationWithBiometrics {
                    self?.result(authResult: .success, data: self?.descContext.evaluatedPolicyDomainState)
                } else {
                    // 解锁定生物识别成功
                    self?.startWith(fallbackTitle: fallbackTitle)
                }
            } else if let error = error as? LAError {
                self?.dealWith(policy: policy, error: error)
            } else {
                self?.result(authResult: .unknown, data: nil)
            }
        }
    }
    
    private func dealWith(policy: LAPolicy, error: LAError) {
        switch error.code {
        case .authenticationFailed:
            self.canceled?(CustomError.deviceError(error))
        case .appCancel, .systemCancel, .userCancel, .invalidContext:
            self.canceled?(nil)
        case .userFallback:
            self.result(authResult: .fallback, data: nil)
        case .passcodeNotSet, .biometryNotEnrolled, .biometryNotAvailable:
            self.result(authResult: .notSet, data: nil)
        case .biometryLockout:
            // 若当前为强制生物识别被锁定，则设置为生物加密码模式，解锁定生物识别
            if policy == .deviceOwnerAuthenticationWithBiometrics {
                self.startWith(fallbackTitle: fallbackTitle)
            } else {
                self.result(authResult: .locked, data: nil)
            }
        case .notInteractive:
            self.result(authResult: .notInteractive, data: nil)
        default:
            self.result(authResult: .unknown, data: nil)
        }
    }
    
    private func result(authResult: DeviceAuthResult, data: Data?) {
        var res = AuthResult.init(authResult: authResult)
        res.evaluatedPolicyDomainState = data
        DispatchQueue.main.async {
            self.authCompletion?(res)
            self.uiCompletion?(res)
        }
    }
}

extension DeviceAuthVerification {
    
    public enum DeviceType {
        case face
        case finger
        
        public init(descContext: LAContext?) {
            let descContext = descContext ?? LAContext()
            if #available(iOS 11.0, *) {
                if descContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
                    self = descContext.biometryType == .faceID ? .face : .finger
                }
                let type = descContext.biometryType
                if type == LABiometryType.LABiometryNone, (UIDevice.current.fy.isFullScreenDevice || Methods.safeAreaInset.bottom > 0) {
                    self = .face
                }
                self = type == .faceID ? .face : .finger
            } else {
                self = .finger
            }
        }
        
        public var des: String {
            switch self {
            case .face:
                return Res.text("面容")
            case .finger:
                return Res.text("指纹")
            }
        }
        
        var reason: String {
            switch self {
            case .face:
                return Res.text("通过摄像头验证已有面容信息")
            case .finger:
                return Res.text("通过Home键验证已有手机指纹")
            }
        }
    }
    
    /// 设备验证结果
    public enum DeviceAuthResult {
        case success
        case fallback
        case notSet
        case notOpen
        case locked // 几乎没用，备用
        case notInteractive // 几乎没用，备用
        case notSupported // 几乎没用，备用。通常通过 deviceSupported 先检测
        case unknown
        
        public func detailDesc() -> String? {
            switch self {
            case .success, .fallback:
                return nil
            case .notSet:
                let deviceType = DeviceType.init(descContext: nil)
                return Res.text("您还未录入") + deviceType.des + Res.text("信息，请前往设置页面进行录入")
            case .notOpen:
                let deviceType = DeviceType.init(descContext: nil)
                return Res.text("您还未开启") + deviceType.des + Res.text("识别，请前往设置页面进行开启")
            case .notSupported:
                let deviceType = DeviceType.init(descContext: nil)
                return Res.text("您的设备暂不支持") + deviceType.des + Res.text("识别")
            case .locked, .notInteractive:
                return Res.text("您的设备已被锁定，请稍后再试")
            case .unknown:
                return Res.text("未知错误，请稍后再试")
            }
        }
    }
}
