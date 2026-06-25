//
//  UIView+hud.swift
//  FeatBox
//
//  Created by Condy on 2023/5/20.
//

import Foundation
import ProductLib
import MBProgressHUD

extension UIView {
    private struct UIViewHUDExtensionKey {
        static var lastHUDView: Void?
    }
    
    fileprivate var lastHUDView: MBProgressHUD? {
        set {
            objc_setAssociatedObject(self, &UIViewHUDExtensionKey.lastHUDView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &UIViewHUDExtensionKey.lastHUDView) as? MBProgressHUD
        }
    }
}

extension BoxWrapper where Base: UIView {
    
    /// 展示飘文
    /// - Parameters:
    ///   - title: 标题信息
    ///   - detail: 文本内容
    ///   - afterDelay: 延迟时间，默认两秒后消失
    ///   - alertCallback: hud
    public func showHUD(title: String, detail: String? = nil, afterDelay: CGFloat = 2.0, alertCallback: ((_ alert: UIView?) -> Void)? = nil) {
        self.hideHUD(false)
        if title.count == 0, detail?.count ?? 0 == 0 {
            return
        }
        base.lastHUDView = MBProgressHUD.showAdded(to: base, animated: true)
        base.lastHUDView?.mode = .text
        base.lastHUDView?.label.text = title
        base.lastHUDView?.label.font = base.lastHUDView?.label.font?.fy.fixedFont
        base.lastHUDView?.label.numberOfLines = 0
        base.lastHUDView?.detailsLabel.text = detail
        base.lastHUDView?.detailsLabel.numberOfLines = 0
        base.lastHUDView?.detailsLabel.font = base.lastHUDView?.detailsLabel.font?.fy.fixedFont
        base.lastHUDView?.hide(animated: true, afterDelay: afterDelay)
        alertCallback?(base.lastHUDView)
        base.lastHUDView = nil
    }
    
    public func hideHUD(_ animated: Bool = true) {
        if base.lastHUDView == nil {
            MBProgressHUD.hide(for: base, animated: animated)
        } else {
            base.lastHUDView?.hide(animated: animated)
            base.lastHUDView = nil
        }
    }
}
