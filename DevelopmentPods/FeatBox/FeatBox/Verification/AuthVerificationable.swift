//
//  AuthVerificationable.swift
//  FeatBox
//
//  Created by Condy on 2023/8/30.
//

import Foundation
import ObjectiveC

public protocol AuthVerificationable: AnyObject {
    
    associatedtype AuthElement
    
    typealias AuthCompletion = (AuthElement) -> Void
    
    typealias Canceled = (_ error: CustomError?) -> Void
    
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
    
    /// 存储弱引用对象，防止被提前释放。使用 weak 容器避免 retain cycle
    /// 验证 VC 释放后会被自动从数组中清理
    private static var managedAuth: [WeakAuthWrapper] {
        get {
            if let managedAuth = objc_getAssociatedObject(self, &AuthVerificationableExtensionKey.managedAuth) {
                return managedAuth as! [WeakAuthWrapper]
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
        Self.managedAuth.removeAll { wrapper in
            wrapper.uuid == self.uuidString || wrapper.target == nil
        }
    }
}

/// 弱引用包装器，用于在静态数组中持有 AuthVerificationable 而不造成 retain cycle
private final class WeakAuthWrapper {
    weak var target: (any AuthVerificationable)?
    let uuid: String
    init(target: any AuthVerificationable, uuid: String) {
        self.target = target
        self.uuid = uuid
    }
}

extension AuthVerificationable {
    
    /// 开始该验证，已在扩展中实现
    /// - Parameters:
    ///   - destinationActionWhenUICompletion: 是否在UI完成之后在处理
    ///   - action: 处理完成事件
    ///   - canceled: 取消事件
    public func startDestinationAction(destinationActionWhenUICompletion: Bool = false, action: AuthCompletion?, canceled: Canceled? = nil) {
        // 使用弱引用包装器持有 self，避免静态数组永远持有 self 造成的 retain cycle
        Self.managedAuth.append(WeakAuthWrapper(target: self, uuid: self.uuidString))
        self.destinationAction = action
        if self.isAuthVerificationPassed() {
            self.destinationAction?(authVerificationPassedInfo)
            self.removeFromManagedAuth()
        } else {
            self.authVerificationAction(authCompletion: { [weak self] (authResult: Self.AuthElement) in
                guard !destinationActionWhenUICompletion else {
                    return
                }
                self?.destinationAction?(authResult)
                self?.removeFromManagedAuth()
            }, uiCompletion: { [weak self] (authResult: Self.AuthElement) in
                guard destinationActionWhenUICompletion else {
                    return
                }
                self?.destinationAction?(authResult)
                self?.removeFromManagedAuth()
            }, canceled: { [weak self] (error: CustomError?) in
                canceled?(error)
                self?.removeFromManagedAuth()
            })
        }
    }
}
