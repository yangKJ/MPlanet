//
//  BaseFormCell.swift
//  FeatBox
//
//  Created by Condy on 2024/5/20.
//

import Foundation
import ProductLib
import RxCocoa
import SnapKit

open class BaseFormCellViewModel: BaseTableViewCellViewModelable {

    open var cellType: BaseTableViewCell.Type {
        BaseFormCell.self
    }

    public var title: String?
    public var accessoryImage: UIImage?

    public var hasArrow: Bool = false {
        didSet {
            accessoryImage = hasArrow ? Res.right_arrow : nil
        }
    }

    public let titleFont = PublishRelay<UIFont?>()
    public let titleTextColor = PublishRelay<UIColor?>()
    public let titleIcon = PublishRelay<String?>()
    public let titleIconURL = PublishRelay<URL?>()
    public let titleIconPlaceholder = PublishRelay<UIImage?>()

    fileprivate var accessoryImageBlock: (() -> Void)?
    public func setAccessoryImageTap(block: @escaping () -> Void) {
        self.accessoryImageBlock = block
    }

    public init() { }
}

/// 表单Cell
open class BaseFormCell: BaseTableViewCell, HasDisposeBag {

    // 修复 binding 时序问题：BaseTableViewCell 在 init 时调用 setupBindings()，
    // 但那时 viewModel 还是 nil，子类的所有 bind 都会静默失效。
    // 现在改为 viewModel.didSet 触发：每次赋值 viewModel 时重新绑定。
    // 配合 prepareForReuse 中 disposeBag = DisposeBag()，保证复用也不会叠加订阅。
    public override var viewModel: BaseTableViewCellViewModelable? {
        didSet {
            applyViewModel(viewModel)
            // viewModel 真正非空后，再做绑定（子类 override 后会触发自己的 setupBindings）
            if let _ = viewModel as? BaseFormCellViewModel {
                self.setupBindingsIfNeeded()
            }
        }
    }

    private func applyViewModel(_ viewModel: BaseTableViewCellViewModelable?) {
        guard let viewModel = viewModel as? BaseFormCellViewModel else {
            return
        }
        self.titleLabel.text = viewModel.title
        if let accessoryImage = viewModel.accessoryImage {
            self.selectionStyle = .default
            self.accessoryImageView.isHidden = false
            self.accessoryImageView.image = accessoryImage
            self.hasArrowViewUpdateSubViewConstraint(true)
        } else {
            self.selectionStyle = .none
            self.accessoryImageView.isHidden = true
            self.hasArrowViewUpdateSubViewConstraint(false)
        }
        self.setupSubViewModel(with: viewModel)
    }

    /// 是否已经为当前 viewModel 执行过 binding
    private var bindingsApplied: Bool = false

    private func setupBindingsIfNeeded() {
        guard !bindingsApplied else { return }
        bindingsApplied = true
        // 委托给子类覆盖的 setupBindings()。子类应负责 disposeBag 清空 + 重新订阅。
        self.setupBindings()
    }

    public lazy var titleLabel: BaseLabel = {
        let label = BaseLabel.init(frame: .zero)
        label.textColor = UIColor.fy.title
        label.font = UIFont.fy.system_16
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    open override func setupConstraint() {
        super.setupConstraint()
        self.contentView.addSubview(self.iconView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.accessoryImageView)
        self.iconView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview()
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
            make.top.greaterThanOrEqualTo(13).priority(.high)
        }
        self.accessoryImageView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
            make.top.greaterThanOrEqualTo(13)
        }
    }

    /// 由 viewModel.didSet 触发，子类应清理 disposeBag 后重新订阅。
    /// BaseTableViewCell 在 init 时仍会调用一次空实现的 setupBindings()，那里 viewModel 一定为 nil，
    /// 子类应通过 guard viewModel as? XXXCellViewModel else { return } 防御。
    open override func setupBindings() {
        super.setupBindings()
        guard let viewModel = viewModel as? BaseFormCellViewModel else {
            return
        }
        // 重置 bag，避免叠加订阅
        if let bagOwner = self as? HasDisposeBag {
            bagOwner.disposeBag = DisposeBag()
        }
        viewModel.titleFont.distinctUntilChanged()
            .bind(to: self.titleLabel.rx.font)
            .disposed(by: disposeBag)
        viewModel.titleTextColor.distinctUntilChanged()
            .bind(to: self.titleLabel.rx.textColor)
            .disposed(by: disposeBag)
        Observable.combineLatest(
            viewModel.titleIcon.asObservable(),
            viewModel.titleIconURL.asObservable(),
            viewModel.titleIconPlaceholder.asObservable(),
            resultSelector: { ($0, $1, $2) }
        ).share(replay: 1).subscribe(onNext: { [weak self] (iconName, iconURL, placeholder) in
            if let iconName = iconName {
                self?.iconView.fy.setImage(with: iconName, placeholder: placeholder)
                self?.remakeIconView()
            } else if iconURL?.absoluteString.count ?? 0 > 0 {
                self?.iconView.fy.setImage(with: iconURL, placeholder: placeholder)
                self?.remakeIconView()
            } else if let placeholder = placeholder {
                self?.iconView.image = placeholder
                self?.remakeIconView()
            } else {
                self?.iconView.image = nil
                self?.remakeTitleLabel()
            }
        }).disposed(by: disposeBag)
    }

    // MARK: - subview methods

    open func hasArrowViewUpdateSubViewConstraint(_ has: Bool) { }

    open func setupSubViewModel(with viewModel: BaseTableViewCellViewModelable?) { }

    // MARK: - private methods

    private var iconView: UIImageView = {
        let imageView = BaseImageView()
        imageView.sizeToFit()
        imageView.isHidden = true
        return imageView
    }()

    private var accessoryImageView: UIImageView = {
        let imageView = BaseImageView(image: Res.right_arrow)
        imageView.sizeToFit()
        imageView.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAccessoryImageClick))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        return imageView
    }()

    private func remakeTitleLabel() {
        self.iconView.isHidden = true
        self.titleLabel.snp.updateConstraints { (make) in
            make.left.equalTo(15)
        }
    }

    private func remakeIconView() {
        self.iconView.isHidden = false
        self.titleLabel.snp.updateConstraints { (make) in
            make.left.equalTo(self.iconView.snp.right).offset(5)
        }
    }

    @objc private func tapAccessoryImageClick(_ tap: UIGestureRecognizer) {
        guard let viewModel = viewModel as? BaseFormCellViewModel else {
            return
        }
        viewModel.accessoryImageBlock?()
    }
}
