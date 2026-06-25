//
//  AlertView.swift
//  FeatBox
//
//  Created by Condy on 2024/9/14.
//

import Foundation
import ProductLib
import SnapKit
import Booming

public final class AlertView: HIStackView {
    
    static let alertWidth: CGFloat = 270
    static let scrollEdge: CGFloat = 5
    static let scrollInset: CGFloat = 15
    
    public func set(icon: UIImage) {
        self.contentView.set(icon: icon)
    }
    
    public func set(title: String, alignment: NSTextAlignment = .center) {
        self.contentView.set(title: title, alignment: alignment)
    }
    
    public func set(detail: String, alignment: NSTextAlignment = .center) {
        self.contentView.set(detail: detail, alignment: alignment)
    }
    
    public func set(attributeTitle: NSAttributedString, alignment: NSTextAlignment = .center) {
        self.contentView.set(attributeTitle: attributeTitle, alignment: alignment)
    }
    
    public func set(attributeDetail: NSAttributedString, alignment: NSTextAlignment = .center) {
        self.contentView.set(attributeDetail: attributeDetail, alignment: alignment)
    }
    
    public func addButton(title: String, isDefault: Bool = false, action: @escaping (UIButton) -> Void) {
        let titleColor = isDefault ? UIColor.fy.linkBlue : UIColor.fy.linkBlue
        let bgColor = isDefault ? UIColor.fy.white : UIColor.fy.white
        self.actionView.addButton(title: title, titleColor: titleColor, bgColor: bgColor, isDefault: isDefault, action: action)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    // MARK: - prviate
    
    private let contentView = AlertContentView()
    private let actionView = AlertActionView()
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    
    private func setupViews() {
        //self.corner_et = 10
        self.containerView.backgroundColor = UIColor.fy.white
        self.asix = .vertical
        scrollView.alwaysBounceHorizontal = false
        self.scrollView.contentInset = UIEdgeInsets(top: 15, left: AlertView.scrollInset, bottom: 10, right: AlertView.scrollInset)
        let view = UIView()
        view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.top.greaterThanOrEqualTo(0)
            make.bottom.lessThanOrEqualTo(0)
        }
        self.scrollView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.width.equalToSuperview().offset(-self.scrollView.contentInset.left - self.scrollView.contentInset.right)
            make.height.equalToSuperview().offset(-self.scrollView.contentInset.top - self.scrollView.contentInset.bottom).priority(2)
            make.edges.equalToSuperview()
            make.height.greaterThanOrEqualTo(60)
        }
        self.containerView.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.bottom.equalTo(-5)
            make.left.equalTo(AlertView.scrollEdge)
            make.right.equalTo(-AlertView.scrollEdge)
        }
    }
}

extension AlertView: LevelStatusBarWindowShowUpable {
    public func makeOpenedStatusConstraint(superview: UIView) {
        self.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(AlertView.alertWidth)
            make.height.lessThanOrEqualToSuperview().offset(-100)
            make.height.equalTo(100).priority(1)
        }
    }
    
    public func refreshBeforeShow() {
        var array = [UIView]()
        array.append(self.containerView)
        let line = ZLineView()
        line.backgroundColor = UIColor.fy.darkLine
        if self.actionView.numberOfButtons() > 0 {
            array.append(line)
            array.append(self.actionView)
        }
        self.set(views: array)
        self.actionView.asix = self.actionView.numberOfButtons() > 2 ? .vertical : .horizontal
        self.contentView.refresh()
        self.actionView.refresh()
        if self.actionView.superview != nil {
            self.actionView.snp.makeConstraints { (make) in
                make.width.equalToSuperview()
                make.height.equalTo(self.actionView.asix == .vertical ? 44*self.actionView.numberOfButtons() : 44)
            }
        }
        if line.superview != nil {
            line.snp.makeConstraints { (make) in
                make.width.equalToSuperview()
            }
        }
    }
    
    public func show(animated: Bool, animation: (() -> Void)?, completion: ((Bool) -> Void)?) {
        self.alpha = 0
        self.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: { [weak self] in
            self?.alpha = 1
            self?.transform = CGAffineTransform.identity
            animation?()
        }, completion: completion)
    }

    public func close(animated: Bool, animation: (() -> Void)?, completion: ((Bool) -> Void)?) {
        let animationBlock = { [weak self] in
            self?.alpha = 0
            animation?()
        }
        if animated {
            UIView.animate(withDuration: 0.2, animations: animationBlock, completion: completion)
        } else {
            animationBlock()
            completion?(true)
        }
    }
    
    public func canCloseWhenTapOutSize() -> Bool {
        return self.actionView.numberOfButtons() == 0
    }
}

class AlertActionView: HIStackView {
    
    private static let buttonTagOffset = 2726
    private var actions = [((UIButton) -> Void)]()
    private var buttons = [UIButton]()
    
    func addButton(title: String, titleColor: UIColor, bgColor: UIColor = UIColor.fy.white, selectedBgColor: UIColor = UIColor.fy.line, isDefault: Bool, action: @escaping (UIButton) -> Void) -> AlertActionView {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setTitle(title, for: UIControl.State.normal)
        button.titleLabel?.font = (isDefault ? UIFont.fy.bold_16 : UIFont.fy.system_16)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(titleColor, for: UIControl.State.normal)
        button.setBackgroundImage(UIImage.fy.colorImage(with: bgColor, size: CGSize(width: 1, height: 1)), for: .normal)
        button.setBackgroundImage(UIImage.fy.colorImage(with: selectedBgColor, size: CGSize(width: 1, height: 1)), for: .highlighted)
        button.tag = actions.count + AlertActionView.buttonTagOffset
        button.addTarget(self, action: #selector(buttonAction(button:)), for: UIControl.Event.touchUpInside)
        actions.append(action)
        buttons.append(button)
        return self
    }
    
    func refresh() {
        var lines = [ZLineView]()
        var views = [UIView]()
        self.buttons.enumerated().forEach { (index, button) in
            views.append(button)
            if index != self.buttons.count-1 {
                let line = ZLineView(asix: self.asix == .vertical ? .horizontal : .vertical)
                line.backgroundColor = UIColor.fy.darkLine
                views.append(line)
                lines.append(line)
            }
        }
        self.set(views: views)
        self.buttons.enumerated().forEach { (offset, element) in
            guard let next = buttons[safe: offset+1] else {
                return
            }
            element.snp.makeConstraints({ (make) in
                switch self.asix {
                case .horizontal:
                    make.width.equalTo(next.snp.width)
                case .vertical:
                    make.height.equalTo(next.snp.height)
                }
            })
        }
        lines.forEach { (line) in
            line.snp.makeConstraints({ (make) in
                switch self.asix {
                case .horizontal:
                    make.height.equalTo(self.snp.height)
                case .vertical:
                    make.width.equalTo(self.snp.width)
                }
            })
        }
    }
    
    func numberOfButtons() -> Int {
        return self.buttons.count
    }
    
    @objc func buttonAction(button: UIButton) {
        let index = button.tag - AlertActionView.buttonTagOffset
        if let action = actions[safe: index] {
            action(button)
        }
    }
}

class AlertContentView: HIStackView {
    
    private var titleLabel: UILabel?
    private var detailLabel: BaseLabel?
    private var iconView: UIImageView?
    
    private var title: String? {
        set {
            guard let title = newValue, !title.isEmpty else {
                self.titleLabel?.removeFromSuperview()
                self.titleLabel = nil
                return
            }
            if self.titleLabel == nil {
                let titleLabel = BaseLabel()
                titleLabel.font = UIFont.fy.bold_16
                titleLabel.textColor = UIColor.fy.navBarTitle
                titleLabel.numberOfLines = 0
                titleLabel.textAlignment = .center
                self.titleLabel = titleLabel
            }
            self.titleLabel?.text = newValue
        }
        get {
            return self.titleLabel?.text
        }
    }
    
    private var attributeTitle: NSAttributedString? {
        set {
            guard let attributeTitle = newValue, !attributeTitle.string.isEmpty else {
                self.titleLabel?.removeFromSuperview()
                self.titleLabel = nil
                return
            }
            if self.titleLabel == nil {
                let titleLabel = BaseLabel()
                titleLabel.font = UIFont.fy.bold_16
                titleLabel.textColor = UIColor.fy.navBarTitle
                titleLabel.numberOfLines = 0
                titleLabel.textAlignment = .center
                self.titleLabel = titleLabel
            }
            self.titleLabel?.attributedText = newValue
        }
        get {
            return self.titleLabel?.attributedText
        }
    }
    
    private var detail: String? {
        set {
            guard let detail = newValue, !detail.isEmpty else {
                self.detailLabel?.removeFromSuperview()
                self.detailLabel = nil
                return
            }
            if self.detailLabel == nil {
                self.detailLabel = BaseLabel()
                self.detailLabel?.font = UIFont.systemFont(ofSize: 13)
                self.detailLabel?.textColor = UIColor.fy.navBarTitle
                self.detailLabel?.numberOfLines = 0
                self.detailLabel?.textAlignment = .center
                self.detailLabel?.lineBreakMode = .byTruncatingTail
            }
            var attributes = [NSAttributedString.Key: Any]()
            attributes[NSAttributedString.Key.foregroundColor] = UIColor.fy.navBarTitle
            attributes[NSAttributedString.Key.font] = UIFont.fy.system_13
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
            let attributedString = NSMutableAttributedString.init(string: newValue ?? "", attributes: attributes)
            self.detailLabel?.attributedText = attributedString
        }
        get {
            return self.detailLabel?.attributedText?.string
        }
    }
    
    private var attributeDetail: NSAttributedString? {
        set {
            guard let attributeDetail = newValue, !attributeDetail.string.isEmpty else {
                self.detailLabel?.removeFromSuperview()
                self.detailLabel = nil
                return
            }
            if self.detailLabel == nil {
                self.detailLabel = BaseLabel()
                self.detailLabel?.font = UIFont.fy.system_13
                self.detailLabel?.textColor = UIColor.fy.navBarTitle
                self.detailLabel?.numberOfLines = 0
                self.detailLabel?.textAlignment = .center
                self.detailLabel?.lineBreakMode = .byTruncatingTail
            }
            self.detailLabel?.attributedText = attributeDetail
        }
        get {
            return self.detailLabel?.attributedText
        }
    }
    
    private var icon: UIImage? {
        set {
            guard newValue != nil else {
                self.iconView?.removeFromSuperview()
                self.iconView = nil
                return
            }
            if self.iconView == nil {
                self.iconView = UIImageView()
                self.iconView?.manageStackFrameByUser = true
            }
            self.iconView?.image = newValue
        }
        get {
            return self.iconView?.image
        }
    }
    
    private func height(of width: CGFloat) -> CGFloat {
        return detailLabel?.height(of: width, font: UIFont.fy.system_13) ?? 0
    }
    
    public func set(icon: UIImage) {
        self.icon = icon
    }
    
    public func set(title: String, alignment: NSTextAlignment = .center) {
        self.title = title
        self.titleLabel?.textAlignment = alignment
    }
    
    public func set(detail: String, alignment: NSTextAlignment = .center) {
        self.detail = detail
        self.detailLabel?.textAlignment = alignment
    }
    
    public func set(attributeTitle: NSAttributedString, alignment: NSTextAlignment = .center) {
        self.attributeTitle = attributeTitle
        self.titleLabel?.textAlignment = alignment
    }
    
    public func set(attributeDetail: NSAttributedString, alignment: NSTextAlignment = .center) {
        self.attributeDetail = attributeDetail
        self.detailLabel?.textAlignment = alignment
    }
    
    /// 根据添加设置内容，刷新界面
    func refresh() {
        var views = [UIView]()
        if let iconView = self.iconView, self.icon != nil {
            iconView.stackEdge = UIEdgeInsets.init(top: 0, left: 0, bottom: 10, right: 0)
            iconView.sizeToFit()
            views.append(iconView)
        }
        if let titleLabel = self.titleLabel, let title = self.title, !title.isEmpty {
            titleLabel.stackEdge = UIEdgeInsets.init(top: 0, left: 0, bottom: 5, right: 0)
            views.append(titleLabel)
        }
        if let detailLabel = self.detailLabel, let detail = self.detail, !detail.isEmpty {
            detailLabel.stackEdge = UIEdgeInsets.zero
            views.append(detailLabel)
        }
        if let last = views.last {
            last.stackEdge = UIEdgeInsets.zero
        }
        self.set(views: views)
        detailLabel?.snp.makeConstraints({ (make) in
            make.height.equalTo(self.height(of: AlertView.alertWidth - AlertView.scrollEdge*2 - AlertView.scrollInset*2))
        })
    }
    
    func isEmpty() -> Bool {
        return self.detail == nil && self.title == nil && self.icon == nil
    }
}

extension UIView {
    private struct StackViewExtensionKey {
        static var stackEdge: Void?
        static var manageStackFrameByUser: Void?
    }
    var stackEdge: UIEdgeInsets? {
        set {
            objc_setAssociatedObject(self, &StackViewExtensionKey.stackEdge, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &StackViewExtensionKey.stackEdge) as? UIEdgeInsets
        }
    }
    
    var manageStackFrameByUser: Bool {
        set {
            objc_setAssociatedObject(self, &StackViewExtensionKey.manageStackFrameByUser, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &StackViewExtensionKey.manageStackFrameByUser) as? Bool ?? false
        }
    }
}
