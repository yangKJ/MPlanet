//
//  WebDecisionHandler.swift
//  FeatBox
//
//  Created by Condy on 2025/5/20.
//

import Foundation
import WebKit
import SmartCodable

class WebDecisionHandler {

    /// 安全修复：仅对受信 host 注入 token。避免"方法名暴露鉴权逻辑"和"未登录页能拿到 token"的问题。
    /// 真实场景下，应通过 Cookie / Authorization Header 由原生侧在每次请求时附加，
    /// 而不是 JS Bridge。这里仍保留反注入作为兜底，但只对受信 host 注入。
    ///
    /// 默认拒绝：空 Set 等价于"任何 host 都不注入 token"。
    /// 生产环境必须通过 `registerTrustedHosts(_:)` 显式注册受信 host 白名单。
    private static var trustedHosts: Set<String> = []
    private static let trustedHostsLock = NSLock()
    // 生产请通过 `WebDecisionHandler.registerTrustedHosts(_:)` 注入可信 host 白名单。

    /// 注册受信 host 白名单。同一进程内多次调用会覆盖。
    /// - Note: 生产请注入可信 host 白名单，例如
    ///   `WebDecisionHandler.registerTrustedHosts(["mplanet.example.com"])`
    public static func registerTrustedHosts(_ hosts: [String]) {
        trustedHostsLock.lock()
        defer { trustedHostsLock.unlock() }
        trustedHosts = Set(hosts)
    }

    /// 注入当前 WebView controller URL 的 host 到受信列表（仅限当前实例的 fallback 路径）。
    /// 用于开发态"未配白名单但想打通"的场景；生产禁止调用。
    public func trustCurrentHostAsFallback() {
        guard let host = controller?.url?.host, !host.isEmpty else { return }
        Self.registerTrustedHosts([host])
    }

    private weak var controller: WebViewController?

    init(controller: WebViewController?) {
        self.controller = controller
    }

    func handleWith(functionName: String, functionBody: [String: Any]?, callback: ((Any?) -> Void)? = nil) {
        switch functionName {
        case "goto":
            goto(params: functionBody)
        case "needLogin":
            let auth = LoginAuthVerification()
            auth.startDestinationAction(destinationActionWhenUICompletion: true, action: { [weak self] _ in
                guard let self = self else { return }
                guard let userToken = Session.shared.loggedUserDTO?.token else {
                    return
                }
                // 修复：仅当当前 WebView 的 host 在 trustedHosts 白名单内才反注入 token。
                // 默认拒绝：空 trustedHosts 时一律不注入 token，避免方法名暴露鉴权逻辑。
                let currentHost = self.controller?.url?.host ?? ""
                Self.trustedHostsLock.lock()
                let isTrusted = Self.trustedHosts.contains(currentHost)
                Self.trustedHostsLock.unlock()
                if isTrusted {
                    self.controller?.callJavaScriptFunction(functionName: "loginSuccess", params: [
                        "userToken": userToken
                    ])
                } else {
                    // 不注入 token，提示 H5 自行从 Cookie / Header 读取
                    self.controller?.callJavaScriptFunction(functionName: "loginSuccess", params: nil)
                }
            }, canceled: nil)
        default:
            break
        }
    }

    private func goto(params: [String: Any]?) {
        guard let item = Banner.deserialize(from: params) else {
            return
        }
        item.goto(from: controller)
    }
}
