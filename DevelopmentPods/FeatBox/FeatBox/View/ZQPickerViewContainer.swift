//
//  ZQPickerViewContainer.swift
//  FeatBox
//
//  Created by Condy on 2024/5/20.
//

import Foundation
import SnapKit
import Booming
import ProductLib

public protocol SubPickerView: UIView {
    associatedtype Element
    init()
    var selectedValue: Element { get }
}

public final class ZQPickerViewContainer<SubView: SubPickerView>: BaseView {
    
    public let pickerView = SubView.init()
    
    public var customizedView: UIView? {
        didSet {
            if oldValue?.superview == self {
                oldValue?.removeFromSuperview()
                self.toolBar.snp.remakeConstraints { (make) in
                    make.top.left.right.equalToSuperview()
                    make.height.equalTo(40)
                }
                self.pickerView.snp.remakeConstraints { (make) in
                    make.left.right.bottom.equalToSuperview()
                    make.top.equalTo(toolBar.snp.bottom)
                    make.height.equalTo(200)
                }
            }
            guard let customizedView = customizedView, customizedView.superview == nil else {
                return
            }
            addSubview(customizedView)
            self.toolBar.snp.remakeConstraints { (make) in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(40)
            }
            customizedView.snp.makeConstraints { make in
                make.top.equalTo(self.toolBar.snp.bottom)
                make.left.right.equalToSuperview()
            }
            self.pickerView.snp.remakeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.top.equalTo(customizedView.snp.bottom)
                make.height.equalTo(200)
            }
        }
    }
    
    public var title: String? {
        didSet {
            (titleItem.customView as? UIButton)?.setTitle(title, for: .normal)
            (titleItem.customView as? UIButton)?.sizeToFit()
        }
    }
    
    public var additionalTitle: String? {
        didSet {
            (additionalItem.customView as? UIButton)?.setTitle(additionalTitle, for: .normal)
            (additionalItem.customView as? UIButton)?.sizeToFit()
            if additionalTitle?.count ?? 0 == 0 {
                self.toolBar.items = [titleItem, UIBarButtonItem.fy.spaceButton(), finishItem]
            } else {
                self.toolBar.items = [titleItem, UIBarButtonItem.fy.spaceButton(), additionalItem, finishItem]
            }
        }
    }
    
    public var finishButtonTitle: String? {
        didSet {
            (finishItem.customView as? UIButton)?.setTitle(finishButtonTitle, for: .normal)
            (finishItem.customView as? UIButton)?.sizeToFit()
        }
    }
    
    private var finishSelectionBlock: ((SubView.Element) -> Void)?
    
    public func setFinishSelectionBlock(block: ((SubView.Element) -> Void)?) {
        self.finishSelectionBlock = block
    }
    
    private var additionalButtonBlock: (() -> Void)?
    
    public func setAdditionalButtonBlock(block: (() -> Void)?) {
        self.additionalButtonBlock = block
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.items = [titleItem, UIBarButtonItem.fy.spaceButton(), finishItem]
        return toolBar
    }()
    
    private lazy var titleItem: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.fy.system_15
        button.setTitleColor(UIColor.fy.black_333333, for: .normal)
        button.setTitleColor(UIColor.fy.black_333333.withAlphaComponent(0.4), for: .disabled)
        button.sizeToFit()
        let width  = max(50, button.frame.size.width)
        let height = max(44, button.frame.size.height)
        button.frame = CGRect(x: 0, y: 0, width: width, height: height)
        button.contentHorizontalAlignment = .left
        let item = UIBarButtonItem.init(customView: button)
        return item
    }()
    
    private lazy var additionalItem: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.fy.system_15
        button.setTitleColor(UIColor.fy.black_333333, for: .normal)
        button.setTitleColor(UIColor.fy.black_333333.withAlphaComponent(0.4), for: .disabled)
        button.sizeToFit()
        let width  = max(50, button.frame.size.width)
        let height = max(44, button.frame.size.height)
        button.frame = CGRect(x: 0, y: 0, width: width, height: height)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(additional), for: .touchUpInside)
        let item = UIBarButtonItem.init(customView: button)
        return item
    }()
    
    private lazy var finishItem: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.fy.system_15
        button.setTitle(Res.text("完成"), for: .normal)
        button.setTitleColor(UIColor.fy.black_333333, for: .normal)
        button.setTitleColor(UIColor.fy.black_333333.withAlphaComponent(0.4), for: .disabled)
        button.sizeToFit()
        let width  = max(50, button.frame.size.width)
        let height = max(44, button.frame.size.height)
        button.frame = CGRect(x: 0, y: 0, width: width, height: height)
        button.contentHorizontalAlignment = .right
        button.addTarget(self, action: #selector(finish), for: .touchUpInside)
        let item = UIBarButtonItem.init(customView: button)
        return item
    }()
    
    private func setup() {
        backgroundColor = UIColor.fy.backgroundGray
        addSubview(toolBar)
        addSubview(pickerView)
        self.toolBar.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        self.pickerView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(toolBar.snp.bottom)
            make.height.equalTo(200)
        }
    }
    
    @objc private func finish() {
        self.finishSelectionBlock?(self.pickerView.selectedValue)
    }
    
    @objc private func additional() {
        self.additionalButtonBlock?()
    }
}

extension ZQPickerViewContainer: LevelStatusBarWindowShowUpable {
    
    public func makeOpenedStatusConstraint(superview: UIView) {
        self.snp.remakeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    public func refreshBeforeShow() {
        
    }
    
    public func show(animated: Bool, animation: (() -> Void)?, completion: ((Bool) -> Void)?) {
        layoutIfNeeded()
        self.transform = CGAffineTransform(translationX: 0, y: self.frame.size.height)
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.transform = CGAffineTransform.identity
            animation?()
        }, completion: completion)
    }

    public func close(animated: Bool, animation: (() -> Void)?, completion: ((Bool) -> Void)?) {
        let animationBlock = { [weak self] in
            self?.transform = CGAffineTransform(translationX: 0, y: self?.frame.size.height ?? 0)
        }
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                animationBlock()
                animation?()
            }, completion: completion)
        } else {
            animationBlock()
            animation?()
            completion?(true)
        }
    }
    
    public func canCloseWhenTapOutSize() -> Bool {
        return true
    }
}
