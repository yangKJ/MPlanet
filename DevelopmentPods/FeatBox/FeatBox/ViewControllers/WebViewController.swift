//
//  WebViewController.swift
//  FeatBox
//
//  Created by Condy on 2025/5/20.
//

import Foundation
import WebKit
import SnapKit
import WKWebViewJavascriptBridge
import RxSwift
import Rickenbacker
import ProductLib
import Security

open class WebViewController: BaseViewController<BaseViewModel>, NavigationBarHiddenable, HasScrollViewable {
    
    public var realScrollView: UIScrollView {
        webView.scrollView
    }
    
    private enum WebViewState {
        case none
        case loading
        case success
        case failed
    }
    
    public var scrollContentInset: UIEdgeInsets? {
        didSet {
            if let scrollContentInset = scrollContentInset {
                self.webView.scrollView.contentInset = scrollContentInset
            }
        }
    }
    
    public var url: URL? {
        didSet {
            guard let url = url, isViewLoaded else {
                return
            }
            loadURL(url: url)
        }
    }
    
    public var htmlContent: String? {
        didSet {
            guard let htmlContent = htmlContent, isViewLoaded else {
                return
            }
            webView.loadHTMLString(htmlContent, baseURL: nil)
        }
    }
    
    private var state = WebViewState.none
    private var descisionHandler: WebDecisionHandler?
    
    private lazy var bridge: WKWebViewJavascriptBridge = {
        let bridge = WKWebViewJavascriptBridge(webView: webView)
        return bridge
    }()
    
    private lazy var configuration: WKWebViewConfiguration = {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        return configuration
    }()
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: self.view.frame, configuration: configuration)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self, forKeyPath: "canGoBack", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        return webView
    }()
    
    private lazy var progressView: CCProgressView = {
        let progressView = CCProgressView()
        progressView.progressColor = UIColor.fy.mainColor
        progressView.backgroundViewColor = UIColor.fy.clear
        progressView.isHidden = true
        return progressView
    }()
    
    private var shouldSetTitle = false
    private var alertCompletionHandler0: (() -> Void)?
    private var alertCompletionHandler1: ((Bool) -> Void)?
    
    deinit {
        if self.isViewLoaded {
            self.webView.removeObserver(self, forKeyPath: "canGoBack")
            self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        }
        NotificationCenter.default.removeObserver(self)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.webView)
        self.view.addSubview(self.progressView)
        progressView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(3)
        }
        self.navigationItem.leftBarButtonItem = setBackBarButtonItem(canGoBack: false)
        
        self.descisionHandler = WebDecisionHandler(controller: self)
        self.setupRegisters()
        
        if let url = self.url {
            loadURL(url: url)
        } else if let html = self.htmlContent {
            self.webView.loadHTMLString(html, baseURL: nil)
        }
    }
    
    func callJavaScriptFunction(functionName: String, params: [String: Any]?) {
        bridge.call(handlerName: functionName, data: params?.toJSONString(), callback: nil)
    }
    
    private func setupRegisters() {
        let handlerNames = [
            "goto", // 通用路由跳转模块
            "needLogin", // 登陆
        ]
        for handlerName in handlerNames {
            bridge.register(handlerName: handlerName, handler: { [weak self] (params, callBack) in
                self?.descisionHandler?.handleWith(functionName: handlerName, functionBody: params)
            })
        }
    }
    
    private func loadURL(url: URL) {
        if url.isFileURL {
            webView.loadFileURL(url, allowingReadAccessTo: url)
        } else {
            webView.load(URLRequest(url: url))
        }
    }
    
    @objc func goBack() {
        if self.webView.canGoBack {
            self.webView.goBack()
            return
        }
        self.backAction()
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "canGoBack" {
            let canGoBack = change?[NSKeyValueChangeKey.newKey] as? Bool ?? false
            var leftItems = [UIBarButtonItem]()
            if let back = setBackBarButtonItem(canGoBack: canGoBack) {
                leftItems.append(back)
            }
            if canGoBack {
                let close = UIBarButtonItem(title: Res.text("关闭"), font: UIFont.fy.system_18, target: self, action: #selector(backAction))
                leftItems.append(close)
            }
            self.navigationItem.leftBarButtonItems = leftItems
        } else if keyPath == "estimatedProgress" {
            let progress = webView.estimatedProgress
            progressView.progress = CGFloat(progress)
            if progress <= 0 || progress >= 1 {
                progressView.isHidden = true
            } else {
                progressView.isHidden = false
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    @objc private func backgroundAlertWillBeCancelled() {
        alertCompletionHandler0?()
        alertCompletionHandler1?(false)
    }
    
    private func setBackBarButtonItem(canGoBack: Bool) -> UIBarButtonItem? {
        var back: UIBarButtonItem?
        let width: CGFloat = canGoBack ? 30 : 50
        if let navigationController = self.navigationController {
            if let _ = self.presentingViewController, navigationController.viewControllers.first == self {
                if canGoBack {
                    back = UIBarButtonItem.fy.popOutButton(target: self, action: #selector(goBack), width: width)
                } else {
                    back = UIBarButtonItem.fy.dismissButton(target: self, action: #selector(goBack), width: width)
                }
            } else if navigationController.viewControllers.first != self {
                back = UIBarButtonItem.fy.popOutButton(target: self, action: #selector(goBack), width: width)
            }
        }
        return back
    }
}

extension WebViewController: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation) {
        self.state = .loading
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
        self.state = .success
        self.isBottomOnce = false
        self.scrollPercent.accept(0.0)
        self.isScrollByCustomer = true
        if self.title == nil || shouldSetTitle {
            self.title = webView.title
            shouldSetTitle = true
        }
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation, withError error: Error) {
        self.state = .failed
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        // 安全修复：仅当是 https 服务端证书挑战时才使用默认验证。
        // 任何非 https 的证书挑战一律拒绝，防止 MITM 攻击入口。
        // 之前实现对任意证书都无条件 trust，是 MITM 入口。
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
           let trust = challenge.protectionSpace.serverTrust,
           CFGetTypeID(trust) == SecTrustGetTypeID() {
            // 使用系统默认的证书验证（ATS 校验），不绕过证书链
            completionHandler(.performDefaultHandling, nil)
        } else {
            // 客户端证书挑战或其他类型：取消认证
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
}

extension WebViewController: WKUIDelegate {
    
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        alertCompletionHandler0 = completionHandler
        let alert = AlertViewController()
        alert.set(title: Res.text("提示"))
        alert.set(detail: message)
        alert.addButton(title: Res.text("确定"), isDefault: true, action: { (_) in
            completionHandler()
            self.alertCompletionHandler0 = nil
        })
        alert.show(completion: nil)
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        alertCompletionHandler1 = completionHandler
        let alert = AlertViewController()
        alert.set(title: Res.text("提示"))
        alert.set(detail: message)
        alert.addButton(title: Res.text("取消"), isDefault: true, action: { (_) in
            completionHandler(false)
            self.alertCompletionHandler1 = nil
        })
        alert.addButton(title: Res.text("确定"), isDefault: false, action: { (_) in
            completionHandler(true)
            self.alertCompletionHandler1 = nil
        })
        alert.show(completion: nil)
    }
}
