//
//  BaseFormDetailCell.swift
//  FeatBox
//
//  Created by Condy on 2024/5/20.
//

import Foundation
import ProductLib
import RxCocoa
import SnapKit

/// 左右排版展示Cell
open class BaseFormDetailCell: BaseTableViewCell {
    
    public let hasArrow = PublishRelay<Bool>()
    public let title = PublishRelay<String?>()
    public let detail = PublishRelay<String?>()
    
    public lazy var titleLabel: UILabel = {
        let label = BaseLabel.init(frame: .zero)
        label.textColor = UIColor.fy.title
        label.font = UIFont.fy.system_16
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    public lazy var detailLabel: UILabel = {
        let label = BaseLabel.init(frame: .zero)
        label.textColor = UIColor.fy.detailTitle
        label.font = UIFont.fy.system_14
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    public var arrowView: UIImageView = {
        let imageView = BaseImageView(image: Res.next_arrow)
        imageView.sizeToFit()
        imageView.isHidden = true
        return imageView
    }()
    
    public required override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        self.setup()
    }
    
    private func setup() {
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.detailLabel)
        self.contentView.addSubview(self.arrowView)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
            make.top.greaterThanOrEqualTo(13)
        }
        self.detailLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
            make.left.greaterThanOrEqualTo(self.titleLabel.snp.right).offset(15)
        }
        self.arrowView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        self.setupCustomViewBinding__()
    }
    
    private func setupCustomViewBinding__() {
        self.title.bind(to: self.titleLabel.rx.text).disposed(by: disposeBag)
        self.detail.bind(to: self.detailLabel.rx.text).disposed(by: disposeBag)
        self.hasArrow.distinctUntilChanged().subscribe(onNext: { [weak self] has in
            self?.selectionStyle = has ? .default : .none
            self?.arrowView.isHidden = !has
            self?.detailLabel.snp.updateConstraints { (make) in
                make.right.equalTo(has ? -33 : -15)
            }
        }).disposed(by: disposeBag)
    }
}
