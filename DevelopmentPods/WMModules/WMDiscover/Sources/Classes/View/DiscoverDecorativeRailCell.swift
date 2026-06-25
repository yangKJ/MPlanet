//
//  DiscoverDecorativeRailCell.swift
//  WMDiscover
//
//  Created by Condy on 2023/10/7.
//

import Foundation
import FeatBox

class DiscoverDecorativeRailCellViewModel: BaseTableViewCellViewModelable {
    var cellType: FeatBox.BaseTableViewCell.Type {
        DiscoverDecorativeRailCell.self
    }
}

class DiscoverDecorativeRailCell: BaseTableViewCell, HasDisposeBag {
    
    override var viewModel: BaseTableViewCellViewModelable? {
        didSet {
            guard let viewModel = viewModel as? DiscoverDecorativeRailCellViewModel,
                  let item = viewModel.datasource as? DiscoverDecorativeRail else {
                return
            }
            //self.backView.backgroundColor = item.backgroundColor?.peel
            self.titleLabel.text = item.title
            self.icon.fy.setImage(with: item.imagePath)
            self.backView.backgroundColor = item.backgroundColor?.wrappedValue
            if let desc = item.desc {
                self.subTitleLabel.isHidden = false
                self.subTitleLabel.text = item.desc
                self.titleLabel.font = UIFont.fy.system_12
                self.remakeSub()
            } else {
                self.subTitleLabel.isHidden = true
                self.titleLabel.font = UIFont.fy.system_14
                self.remake()
            }
        }
    }
    
    lazy var titleLabel: BaseLabel = {
        let label = BaseLabel.init(frame: .zero)
        label.textColor = UIColor.fy.black
        label.font = UIFont.fy.system_14
        return label
    }()
    
    lazy var subTitleLabel: BaseLabel = {
        let label = BaseLabel.init(frame: .zero)
        label.textColor = UIColor.fy.detailTitle
        label.font = UIFont.fy.system(8)
        return label
    }()
    
    lazy var icon: BaseImageView = {
        let imageView = BaseImageView.init()
        imageView.backgroundColor = .red
        imageView.sizeToFit()
        return imageView
    }()
    
    lazy var backView: BaseView = {
        let view = BaseView.init()
        view.layer.cornerRadius = 2
        view.layer.masksToBounds = true
        return view
    }()
    
    override func setupConstraint() {
        self.backgroundColor = UIColor.fy.white
        self.contentView.addSubview(backView)
        self.backView.addSubview(titleLabel)
        self.backView.addSubview(subTitleLabel)
        self.backView.addSubview(icon)
        self.backView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
        }
        self.icon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.width.height.equalTo(30)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        self.titleLabel.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(15)
            make.centerY.equalToSuperview()
            //make.top.greaterThanOrEqualTo(15).priority(.high)
        }
        self.subTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(15)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    private func remakeSub() {
        self.titleLabel.snp.remakeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(15)
            make.bottom.equalTo(subTitleLabel.snp.top).offset(-5)
        }
    }
    
    private func remake() {
        self.titleLabel.snp.remakeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(15)
            make.centerY.equalToSuperview()
        }
    }
}
