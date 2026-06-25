//
//  AlertViewController.swift
//  FeatBox
//
//  Created by Condy on 2024/5/20.
//

import Foundation
import Booming

public final class AlertViewController: LevelStatusBarWindowController {
    
    private var dismissBeforeAction = false
    private var dismissNoneAnimated = false
    
    public func set(dismissBeforeAction: Bool) {
        self.dismissBeforeAction = dismissBeforeAction
    }
    
    public func set(dismissNoneAnimated: Bool) {
        self.dismissNoneAnimated = dismissNoneAnimated
    }
    
    public func set(icon: UIImage?) {
        if let icon = icon {
            contentView?.set(icon: icon)
        }
    }
    
    public func set(title: String?, alignment: NSTextAlignment = .center) {
        if let title = title {
            contentView?.set(title: title, alignment: alignment)
        }
    }
    
    public func set(detail: String?, alignment: NSTextAlignment = .center) {
        if let detail = detail {
            contentView?.set(detail: detail, alignment: alignment)
        }
    }
    
    public func set(attributeTitle: NSAttributedString?, alignment: NSTextAlignment = .center) {
        if let attributeTitle = attributeTitle {
            contentView?.set(attributeTitle: attributeTitle, alignment: alignment)
        }
    }
    
    public func set(attributeDetail: NSAttributedString?, alignment: NSTextAlignment = .center) {
        if let attributeDetail = attributeDetail {
            contentView?.set(attributeDetail: attributeDetail, alignment: alignment)
        }
    }
    
    /// 添加按钮
    /// - Parameters:
    ///   - title: 按钮标题
    ///   - isDefault: 是否默认按钮
    ///   - autoClose: 是否自动关闭
    ///   - action: 点击事件，不包含hide操作
    public func addButton(title: String, isDefault: Bool = false, autoClose: Bool = true, action: ((UIButton) -> Void)?) {
        contentView?.addButton(title: title, isDefault: isDefault, action: { [weak self] (button) in
            if autoClose && (self?.dismissBeforeAction ?? false) {
                self?.close(animated: action == nil ? true : !(self?.dismissNoneAnimated ?? false))
            }
            if let action = action {
                action(button)
            }
            if autoClose && !(self?.dismissBeforeAction ?? false) {
                self?.close(animated: action == nil ? true : !(self?.dismissNoneAnimated ?? false))
            }
        })
    }
    
    public override func initShowUpViewIfNeed() {
        showUpView = AlertView()
    }
    
    private var contentView: AlertView? {
        self.showUpView as? AlertView
    }
}
