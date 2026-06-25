//
//  BaseViewController.swift
//  FeatBox
//
//  Created by Condy on 2023/5/20.
//

import Foundation
import Rickenbacker
import ProductLib
import RxSwift
import UIKit

/// 页面状态枚举,统一 loading / content / empty / error 四态
public enum ViewState {
    case loading
    case content
    case empty
    case error
}

open class BaseViewController<T: BaseViewModel>: VMViewController<T>, UIScrollViewDelegate {

    /// 加载中视图,lazy 初始化避免未使用时不创建
    public lazy var loadingView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        v.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: v.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: v.centerYAnchor)
        ])
        return v
    }()

    /// 空态视图,默认展示"暂无数据"
    public lazy var emptyView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        let label = UILabel()
        label.text = "暂无数据"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        v.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: v.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: v.centerYAnchor)
        ])
        return v
    }()

    /// 错误态视图,默认展示"加载失败"
    public lazy var errorView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        let label = UILabel()
        label.text = "加载失败"
        label.textColor = .systemRed
        label.textAlignment = .center
        v.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: v.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: v.centerYAnchor)
        ])
        return v
    }()

    /// 状态容器,叠加在 self.view 上,只显示当前态
    private var stateContainer: UIView?

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.fy.background

        if let scrollSelf = self as? HasScrollViewable {
            scrollSelf.realScrollView.delegate = self
        }
    }

    /// 切换页面状态
    /// - Parameter state: 目标状态(loading/content/empty/error)
    public func showState(_ state: ViewState) {
        // 移除旧的 state 视图
        stateContainer?.removeFromSuperview()
        stateContainer = nil

        let target: UIView?
        switch state {
        case .loading: target = loadingView
        case .content: target = nil
        case .empty:   target = emptyView
        case .error:   target = errorView
        }

        guard let target = target else {
            // content 态,恢复 scroll/list 可见性
            return
        }

        target.frame = self.view.bounds
        target.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(target)
        stateContainer = target
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard var scrollSelf = self as? HasScrollViewable else {
            return
        }
        if scrollSelf.isScrollByCustomer, !scrollSelf.isBottomOnce {
            let scrollViewHeight = scrollView.frame.size.height
            let scrollContentSizeHeight = scrollView.contentSize.height
            let scrollOffset = scrollView.contentOffset.y
            let percent: CGFloat = (scrollOffset + scrollViewHeight)/scrollContentSizeHeight
            if scrollSelf.scrollPercent.value < percent {
                (self as? HasScrollViewable)?.scrollPercent.accept(percent)
            }
            if scrollOffset >= scrollContentSizeHeight - scrollViewHeight {
                (self as? HasScrollViewable)?.isBottomOnce = true
            }
        }
    }
}
