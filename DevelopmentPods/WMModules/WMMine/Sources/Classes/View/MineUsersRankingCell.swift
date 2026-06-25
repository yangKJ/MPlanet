//
//  MineUsersRankingCell.swift
//  WMMine
//
//  Created by Condy on 2023/6/6.
//

import Foundation
import FeatBox

class MineUsersRankingCellViewModel: BaseTableViewCellViewModelable {
    var cellType: FeatBox.BaseTableViewCell.Type {
        MineUsersRankingCell.self
    }
}

class MineUsersRankingCell: BaseTableViewCell, HasDisposeBag {

    override var viewModel: BaseTableViewCellViewModelable? {
        didSet {
            guard let viewModel = viewModel as? MineUsersRankingCellViewModel else {
                return
            }
            self.titleLabel.text = viewModel.datasource as? String
        }
    }

    lazy var titleLabel: UILabel = {
        let label = BaseLabel.init()
        // 美化：标题字号 system_16 + 标题色（深色），与 Discover 列表项一致
        label.font = UIFont.fy.system_16
        label.textColor = UIColor.fy.title
        return label
    }()

    lazy var arrow: UIImageView = {
        let imageView = BaseImageView()
        // 美化：箭头颜色换成 gray_999999，与浅色背景协调
        imageView.image = Res.right_arrow?.c7.tinted(color: .fy.gray_999999)
        return imageView
    }()

    /// 美化：白卡容器
    private let cardView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.fy.white
        v.layer.cornerRadius = 12
        v.layer.masksToBounds = true
        return v
    }()

    override func setupConstraint() {
        // 美化：灰背景 + 白卡
        backgroundColor = UIColor.fy.backgroundGray
        contentView.backgroundColor = UIColor.fy.backgroundGray

        contentView.addSubview(cardView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(arrow)

        // 卡片间距：上下 4pt，左右 12pt
        cardView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(14)
            make.top.equalToSuperview().offset(14)
            make.bottom.equalToSuperview().offset(-14)
        }
        arrow.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.right.equalToSuperview().offset(-14)
        }
    }

    override func setupBindings() {

    }
}
