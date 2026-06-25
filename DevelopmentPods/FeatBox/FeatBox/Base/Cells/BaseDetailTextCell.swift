//
//  BaseDetailTextCell.swift
//  FeatBox
//
//  Created by Condy on 2024/5/20.
//

import Foundation
import ProductLib
import RxCocoa
import SnapKit

public final class BaseDetailTextCellViewModel: BaseFormCellViewModel {

    public var detail: String?
    public var placeholder: String?

    public let detailFont = PublishRelay<UIFont?>()
    public let detailTextColor = PublishRelay<UIColor?>()
    public let detailIcon = PublishRelay<String?>()
    public let detailIconURL = PublishRelay<URL?>()
    public let detailIconPlaceholder = PublishRelay<UIImage?>()
    public let detailNumberOfLines = PublishRelay<Int>()
    public let detailTextAlignment = PublishRelay<NSTextAlignment>()
}

/// 左右排版展示Cell
open class BaseDetailTextCell: BaseFormCell {

    open override func setupSubViewModel(with viewModel: BaseTableViewCellViewModelable?) {
        guard let viewModel = viewModel as? BaseDetailTextCellViewModel else {
            return
        }
        if let detail = viewModel.detail, !detail.isEmpty {
            self.detailLabel.text = detail
        } else {
            self.detailLabel.text = viewModel.placeholder
        }
    }

    open override func hasArrowViewUpdateSubViewConstraint(_ has: Bool) {
        self.detailLabel.snp.updateConstraints { (make) in
            make.right.equalTo(has ? -30 : -15)
        }
    }

    open override func setupConstraint() {
        super.setupConstraint()
        self.contentView.addSubview(self.detailLabel)
        self.contentView.addSubview(self.detailIconView)
        self.detailLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
            make.top.greaterThanOrEqualTo(13)
            make.left.greaterThanOrEqualTo(self.titleLabel.snp.right).offset(15)
        }
        self.detailIconView.snp.makeConstraints { (make) in
            make.left.greaterThanOrEqualTo(self.titleLabel.snp.right).offset(15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
    }

    open override func setupBindings() {
        super.setupBindings()
        guard let viewModel = viewModel as? BaseDetailTextCellViewModel else {
            return
        }
        // 重置 bag，避免叠加订阅
        if let bagOwner = self as? HasDisposeBag {
            bagOwner.disposeBag = DisposeBag()
        }
        viewModel.titleFont.distinctUntilChanged()
            .bind(to: self.detailLabel.rx.font)
            .disposed(by: disposeBag)
        viewModel.titleTextColor.distinctUntilChanged()
            .bind(to: self.detailLabel.rx.textColor)
            .disposed(by: disposeBag)
        viewModel.detailNumberOfLines.distinctUntilChanged()
            .bind(to: self.detailLabel.rx.numberOfLines)
            .disposed(by: disposeBag)
        viewModel.detailTextAlignment.distinctUntilChanged()
            .bind(to: self.detailLabel.rx.textAlignment)
            .disposed(by: disposeBag)
        Observable.combineLatest(
            viewModel.detailIcon.asObservable(),
            viewModel.detailIconURL.asObservable(),
            viewModel.detailIconPlaceholder.asObservable(),
            resultSelector: { ($0, $1, $2) }
        ).share(replay: 1).subscribe(onNext: { [weak self] (iconName, iconURL, placeholder) in
            if let iconName = iconName {
                self?.detailIconView.fy.setImage(with: iconName, placeholder: placeholder)
                self?.remakeIconView()
            } else if iconURL?.absoluteString.count ?? 0 > 0 {
                self?.detailIconView.fy.setImage(with: iconURL, placeholder: placeholder)
                self?.remakeIconView()
            } else if let placeholder = placeholder {
                self?.detailIconView.image = placeholder
                self?.remakeIconView()
            } else {
                self?.detailIconView.image = nil
                self?.remakeDetailView()
            }
        }).disposed(by: disposeBag)
    }

    // MARK: - private methods

    private lazy var detailLabel: UILabel = {
        let label = BaseLabel.init(frame: .zero)
        label.textColor = UIColor.fy.detailTitle
        label.font = UIFont.fy.system_14
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()

    private var detailIconView: UIImageView = {
        let imageView = BaseImageView()
        imageView.sizeToFit()
        imageView.isHidden = true
        return imageView
    }()

    private func remakeIconView() {
        self.detailIconView.snp.remakeConstraints { (make) in
            make.left.greaterThanOrEqualTo(self.titleLabel.snp.right).offset(15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        self.detailLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self.detailIconView.snp.right).offset(4)
            make.centerY.equalToSuperview()
            make.right.equalTo(-20)
        }
    }

    private func remakeDetailView() {
        self.detailLabel.snp.remakeConstraints { (make) in
            make.left.greaterThanOrEqualTo(self.titleLabel.snp.right).offset(20)
            make.top.greaterThanOrEqualTo(14)
            make.centerY.equalToSuperview()
            make.right.equalTo(-20)
        }
    }
}
