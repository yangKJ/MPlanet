//
//  AuthVerficationable.swift
//  Alamofire
//
//  Created by Condy on 2023/8/30.
//

import Foundation
import ObjectiveC

public protocol AuthVerificationable: NSObjectProtocol {
    
    associatedtype AuthElement
    
    typealias AuthCompletion = (AuthElement) -> Void
    
    typealias Canceled = (_ error: Error?) -> Void
    
    /// 验证已授权通过的信息内容
    var authVerificationPassedInfo: AuthElement { get }
    
    /// 是否通过验证
    /// - Returns: 是否通过验证
    func isAuthVerificationPassed() -> Bool
    
    /// 验证的具体行为，每个子验证去实现
    /// - Parameters:
    ///   - authCompletion: 验证完成后调用
    ///   - uiCompletion: 验证UI完成后调用
    ///   - canceled: 验证错误取消
    func authVerificationAction(authCompletion: AuthCompletion?, uiCompletion: AuthCompletion?, canceled: Canceled?)
}

private struct AuthVerificationableExtensionKey {
    static var destinationAction: Void?
    static var managedAuth: Void?
    static var UUID: Void?
}

extension AuthVerificationable {
    
    private var destinationAction: AuthCompletion? {
        get {
            return objc_getAssociatedObject(self, &AuthVerificationableExtensionKey.destinationAction) as? AuthCompletion
        }
        set {
            objc_setAssociatedObject(self, &AuthVerificationableExtensionKey.destinationAction, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private var uuidString: String {
        get {
            if let uuid = objc_getAssociatedObject(self, &AuthVerificationableExtensionKey.UUID) {
                return uuid as! String
            } else {
                let uuid = Foundation.UUID().uuidString
                objc_setAssociatedObject(self, &AuthVerificationableExtensionKey.UUID, uuid, .OBJC_ASSOCIATION_COPY_NONATOMIC)
                return uuid
            }
        }
        set {
            objc_setAssociatedObject(self, &AuthVerificationableExtensionKey.UUID, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    /// 存储对象，防止被提前释放
    private static var managedAuth: [any AuthVerificationable] {
        get {
            if let managedAuth = objc_getAssociatedObject(self, &AuthVerificationableExtensionKey.managedAuth) {
                return managedAuth as! [any AuthVerificationable]
            } else {
                objc_setAssociatedObject(self, &AuthVerificationableExtensionKey.managedAuth, [], .OBJC_ASSOCIATION_COPY_NONATOMIC)
                return []
            }
        }
        set {
            objc_setAssociatedObject(self, &AuthVerificationableExtensionKey.managedAuth, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    private func removeFromManagedAuth() {
        if let index = Self.managedAuth.firstIndex(where: {
            $0.uuidString == self.uuidString
        }) {
            Self.managedAuth.remove(at: index)
        }
    }
}

extension AuthVerificationable {
    
    /// 开始该验证，已在扩展中实现
    /// - Parameters:
    ///   - destinationActionWhenUICompletion: 是否在UI完成之后在处理
    ///   - action: 处理完成事件
    ///   - canceled: 取消事件
    public func startDestinationAction(destinationActionWhenUICompletion: Bool = false, action: AuthCompletion?, canceled: Canceled? = nil) {
        Self.managedAuth.append(self)
        self.destinationAction = action
        if self.isAuthVerificationPassed() {
            self.destinationAction?(authVerificationPassedInfo)
            self.removeFromManagedAuth()
        } else {
            self.authVerificationAction(authCompletion: { [weak self] in
                guard !destinationActionWhenUICompletion, let weakSelf = self else {
                    return
                }
                weakSelf.destinationAction?($0)
                weakSelf.removeFromManagedAuth()
            }, uiCompletion: { [weak self] in
                guard destinationActionWhenUICompletion, let weakSelf = self else {
                    return
                }
                weakSelf.destinationAction?($0)
                weakSelf.removeFromManagedAuth()
            }, canceled: { [weak self] in
                guard let weakSelf = self else {
                    return
                }
                canceled?($0)
                weakSelf.removeFromManagedAuth()
            })
        }
    }
}
