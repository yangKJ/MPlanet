//
//  CCSearchBar.swift
//  FeatBox
//
//  Created by Condy on 2022/4/25.
//

import Foundation
import SnapKit
import RxSwift
import RxCocoa

/// 搜索控件
open class CCSearchBar: UIView {
    
    private lazy var leftIconView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(leftIconTap)))
        return view
    }()
    
    private lazy var rightIconView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rightIconTap)))
        return view
    }()
    
    // 修复：disposeBag 之前是 lazy 闭包内的局部变量，闭包返回时 disposeBag 出作用域被释放，
    // 导致 tf.rx.text.orEmpty 订阅立即 dispose，文本输入永远不会触发 inputTextFieldEvent
    private let searchBarDisposeBag = DisposeBag()

    public lazy var textField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.textColor = UIColor.init(red: 102, green: 102, blue: 102, alpha: 1)
        tf.returnKeyType = .search
        tf.rx.text.orEmpty
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind(to: self.inputTextFieldEvent)
            .disposed(by: self.searchBarDisposeBag)
        return tf
    }()
    
    /// 文本输入变化事件监听，0.3秒响应一次
    public let inputTextFieldEvent: PublishRelay<String> = PublishRelay()
    
    private var didMoveToSuperViewBlock: ((UIView) -> Void)?
    public func setDidMoveToSuperViewBlock(didMoveToSuperViewBlock: ((UIView) -> Void)?) {
        self.didMoveToSuperViewBlock = didMoveToSuperViewBlock
    }
    
    public var leftIcon: UIImage? {
        didSet {
            refresh()
        }
    }
    
    public var rightIcon: UIImage? {
        didSet {
            refresh()
        }
    }
    
    public var placeholder: String? {
        didSet {
            refresh()
        }
    }
    
    public var placeholderFont: UIFont = UIFont.systemFont(ofSize: 15) {
        didSet {
            refresh()
        }
    }
    
    public var placeholderColor: UIColor = UIColor.init(red: 204, green: 204, blue: 204, alpha: 1) {
        didSet {
            refresh()
        }
    }
    
    private var leftIconTapBlock: (() -> Void)?
    public func setLeftIconTapBlock(leftIconTapBlock: (() -> Void)?) {
        self.leftIconTapBlock = leftIconTapBlock
    }
    
    private var rightIconTapBlock: (() -> Void)?
    public func setRightIconTapBlock(rightIconTapBlock: (() -> Void)?) {
        self.rightIconTapBlock = rightIconTapBlock
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public func makeNaviTitleViewConstraints() {
        let ax = (Int(UIDevice.current.systemVersion.components(separatedBy: ".").first ?? "0") ?? 0)
        guard ax <= 10, self.superview != nil else {
            return
        }
        self.snp.remakeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(6)
            make.bottom.equalTo(-6)
        }
    }
}

extension CCSearchBar {
    
    open override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @discardableResult open override func resignFirstResponder() -> Bool {
        textField.resignFirstResponder()
        return super.resignFirstResponder()
    }
    
    @discardableResult open override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        return textField.becomeFirstResponder()
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        didMoveToSuperViewBlock?(self)
    }
}

extension CCSearchBar {
    
    private func setup() {
        backgroundColor = UIColor.init(red: 247, green: 247, blue: 247, alpha: 1)
        addSubview(leftIconView)
        addSubview(rightIconView)
        addSubview(textField)
        refresh()
    }
    
    @objc private func leftIconTap() {
        leftIconTapBlock?()
    }
    
    @objc private func rightIconTap() {
        rightIconTapBlock?()
    }
    
    private func refresh() {
        let attribute = NSAttributedString(string: placeholder ?? "", attributes: [
            NSAttributedString.Key.foregroundColor: placeholderColor,
            NSAttributedString.Key.font: placeholderFont,
        ])
        textField.attributedPlaceholder = attribute
        textField.snp.remakeConstraints { (make) in
            if leftIcon == nil {
                make.left.equalTo(10)
            } else {
                make.left.equalTo(leftIconView.snp.right).offset(2)
            }
            if rightIcon == nil {
                make.right.equalTo(-10)
            } else {
                make.right.equalTo(rightIconView.snp.left).offset(-2)
            }
            make.top.bottom.equalTo(0)
            make.height.equalTo(32).priority(.high)
        }
        leftIconView.image = leftIcon
        leftIconView.isHidden = leftIcon == nil
        leftIconView.snp.remakeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
            make.width.equalTo(leftIconView.image?.size.width ?? 0)
            make.height.equalTo(leftIconView.image?.size.height ?? 0)
        }
        rightIconView.image = rightIcon
        rightIconView.isHidden = rightIcon == nil
        rightIconView.snp.remakeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
            make.width.equalTo(rightIconView.image?.size.width ?? 0)
            make.height.equalTo(rightIconView.image?.size.height ?? 0)
        }
    }
}
