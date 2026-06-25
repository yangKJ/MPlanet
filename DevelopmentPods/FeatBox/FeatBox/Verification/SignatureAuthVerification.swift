//
//  SignatureAuthVerification.swift
//  WMDiscover
//
//  Created by Condy on 2023/5/20.
//

import Foundation
import ProductLib

/// 签名验证，内部封装的有签名控件
public final class SignatureAuthVerification: NSObject, AuthVerificationable {
    public typealias AuthElement = String?
    
    public var authVerificationPassedInfo: String? {
        nil
    }
    
    public enum SignatureType {
        case userName
    }
    
    public var signatureType: SignatureType = .userName
    
    public var navigationController: UINavigationController?
    
    public var placeholder: String?
    
    private(set) var willCloseByUserBlock: ((SignatureViewController) -> Void)?
    public func setWillCloseByUserBlock(_ block: @escaping (SignatureViewController) -> Void) {
        self.willCloseByUserBlock = block
    }
    
    public func isAuthVerificationPassed() -> Bool {
        return false
    }
    
    public func authVerificationAction(authCompletion: AuthCompletion?, uiCompletion: AuthCompletion?, canceled: Canceled?) {
        let vc = SignatureViewController()
        vc.placeholder = signatureType.setPlaceholder(placeholder)
        vc.setImageBase64Block(block: { [weak self, weak vc] base64 in
            switch self?.signatureType {
            case .userName:
                // 模拟验证签名信息
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    vc?.view.fy.hideHUD()
                    authCompletion?(base64)
                    vc?.backAction()
                    uiCompletion?(base64)
                }
            case .none:
                canceled?(nil)
            }
        })
        if let willCloseByUserBlock = willCloseByUserBlock {
            vc.setWillCloseByUserBlock({ [weak self] vc_ in
                if let vc_ = vc_ as? SignatureViewController {
                    willCloseByUserBlock(vc_)
                }
            })
        }
        let navigationController = navigationController ?? {
            UIViewController.fy.currentViewController()?.navigationController
        }()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SignatureAuthVerification.SignatureType {
    
    func setPlaceholder(_ placeholder: String?) -> String? {
        if let placeholder = placeholder {
            return placeholder
        }
        switch self {
        case .userName:
            return Res.text("测试文字").fy.insert(between: " ")
        }
    }
}
