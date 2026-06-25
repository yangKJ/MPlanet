//
//  BaseWebView.swift
//  FeatBox
//
//  Created by Condy on 2024/5/20.
//

import Foundation
import WebKit
import ProductLib
import RxCocoa
import SnapKit

open class BaseWebView: WKWebView, Storyboardable {

    private lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.progressTintColor = UIColor.fy.blue_1687FF
        return view
    }()

    public init() {
        let config = WKWebViewConfiguration()
        config.preferences = WKPreferences()
        config.preferences.javaScriptEnabled = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        config.userContentController = WKUserContentController()
        config.processPool = WKProcessPool()
        super.init(frame: .zero, configuration: config)
        self.setup()
        self.setupViews()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        allowsBackForwardNavigationGestures = true
        
        /// 观察加载进度
        let progress = rx.observeWeakly(Double.self, #keyPath(BaseWebView.estimatedProgress))
            .map { Float($0 ?? 0) }
            .share(replay: 1, scope: .forever)
        
        progress
            .bind(to: progressView.rx.progress)
            .disposed(by: rx.disposeBag)
        
        progress
            .map { $0 >= 0.99 }
            .bind(to: progressView.rx.isHidden)
            .disposed(by: rx.disposeBag)
    }
    
    private func setupViews() {
        self.addSubview(progressView)
        progressView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(2)
        }
    }
}
