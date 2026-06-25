//
//  LoginAuthVerification.swift
//  FeatBox
//
//  Created by Condy on 2023/8/30.
//

import Foundation
import ProductLib
import SmartCodable
import RxSwift

/// 登陆验证，内部会主动拉起登陆控件
public final class LoginAuthVerification: NSObject, AuthVerificationable {
    
    public typealias AuthElement = UserDTO?
    
    public var authVerificationPassedInfo: UserDTO? {
        Session.shared.loggedUserDTO
    }
    
    public func isAuthVerificationPassed() -> Bool {
        return Session.shared.loginState == .logged
    }
    
    public var isMainThread: Bool = true
    
    public func authVerificationAction(authCompletion: AuthCompletion?, uiCompletion: AuthCompletion?, canceled: Canceled?) {
        let vc = UIViewController.fy.currentViewController()
        if Session.shared.loginState == .logging {
            vc?.view?.fy.showHUD(title: Res.text("正在登录中，请稍后"))
            return
        }
        // 登陆处理...
        Session.shared.loginState = .logging
        vc?.view.fy.showHUD(title: Res.text("模拟登陆ing.."))
        login(username: "admin", password: "<MOCK_PASSWORD>").subscribe(onSuccess: { userDTO in
            authCompletion?(userDTO)
            vc?.view.fy.hideHUD()
            uiCompletion?(userDTO)
        }, onFailure: { error in
            canceled?(CustomError.error(error))
        }).disposed(by: rx.disposeBag)
    }
    
    // 模拟用户登录
    func login(username: String, password: String) -> Single<UserDTO> {
        return Single.create { [weak self] single in
            // 模拟网络请求延迟
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
                let json = [
                    "token": "<MOCK_TOKEN>",
                    // hasPrivilegeBarItem 触发 WMTabBarController 动态插入钱包 Tab
                    "hasPrivilegeBarItem": "TAB_BAR_WALLET",
                    "account_type": 0
                ]
                if let userDTO = UserDTO.deserialize(from: json) {
                    Session.shared.loggedSuccess(userDTO)
                    if self?.isMainThread ?? true {
                        DispatchQueue.main.async {
                            single(.success(userDTO))
                        }
                    } else {
                        single(.success(userDTO))
                    }
                } else {
                    // 修复：SmartCodable 反序列化失败时，旧的空 else 会静默吞掉错误，
                    // 调用方永远收不到结果。改为显式 single(.failure) 让外层走 errorSubject。
                    single(.failure(NSError(domain: "LoginAuthVerification",
                                            code: -1,
                                            userInfo: [NSLocalizedDescriptionKey: "UserDTO deserialize failed"])))
                }
            }
            return Disposables.create { }
        }
    }
}

// MARK: - async/await 适配器
// 任务 5.2:为已有 Rx 风格 login() 包一层 async/await,方便 Swift Concurrency 调用方使用。
// 不要重写整个文件(A.7 由 Agent X 处理)。
public extension LoginAuthVerification {
    func login() async throws -> UserDTO {
        return try await withCheckedThrowingContinuation { cont in
            login(username: "admin", password: "<MOCK_PASSWORD>")
                .subscribe(onSuccess: { dto in
                    cont.resume(returning: dto)
                }, onFailure: { err in
                    cont.resume(throwing: err)
                })
                .disposed(by: rx.disposeBag)
        }
    }
}
