//
//  MineUsersHeaderCell.swift
//  WMMine
//
//  Created by Condy on 2023/6/6.
//

import Foundation
import FeatBox

class MineUsersHeaderCellViewModel: BaseTableViewCellViewModelable {
    var cellType: FeatBox.BaseTableViewCell.Type {
        MineUsersHeaderCell.self
    }
    
    let signInEvent = PublishRelay<Void>()
}

class MineUsersHeaderCell: BaseTableViewCell, HasDisposeBag {

    override var viewModel: BaseTableViewCellViewModelable? {
        didSet {
            guard let viewModel = viewModel as? MineUsersHeaderCellViewModel,
                  let user = viewModel.datasource as? MineUsers else {
                return
            }
            self.nameLabel.text = user.name
            self.locationLabel.text = Res.text("地址：") + (user.location ?? "")
            self.headerImageView.fy.setImage(with: user.avatar_url, placeholder: Placeholder.webImage)
            self.stackView.subviews.enumerated().forEach({
                if let label = $1.subviews[safe: 0] as? BaseLabel {
                    switch $0 {
                    case 0:
                        label.text = user.following?.fy.toString()
                    case 1:
                        label.text = user.followers?.fy.toString()
                    case 2:
                        label.text = user.public_repos?.fy.toString()
                    default:
                        break
                    }
                }
            })
        }
    }

    /// 渐变绿背景层（与 Discover 导航栏统一品牌色）
    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.fy.mainColor.cgColor,
            UIColor.fy.mainColor.withAlphaComponent(0.82).cgColor
        ]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        return layer
    }()

    /// 白卡容器：把用户信息区域包成圆角卡片
    private let cardView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.fy.white
        v.layer.cornerRadius = 12
        v.layer.masksToBounds = true
        return v
    }()

    /// 渐变绿色"装饰条"，贴在卡片顶部，与导航栏渐变衔接
    private let gradientBar: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.fy.clear
        return v
    }()

    lazy var headerImageView: UIImageView = {
        var imageView = BaseImageView()
        imageView.fy.cornerRadius = 30
        imageView.fy.borderPxwidthAndColor(UIColor.fy.white, px: 4)
        return imageView
    }()

    lazy var nameLabel: UILabel = {
        let label = BaseLabel.init()
        // 美化：用户名升级 bold_18，更显眼
        label.font = UIFont.fy.bold_18
        label.textColor = UIColor.fy.title
        return label
    }()

    lazy var locationLabel: UILabel = {
        let label = BaseLabel.init()
        label.font = UIFont.fy.system_13
        label.textColor = UIColor.fy.gray_999999
        label.numberOfLines = 0
        return label
    }()

    lazy var signInButton: UIButton = {
        var button = BaseButton.init()
        button.setTitle(Res.text("签到"), for: .normal)
        button.setTitleColor(UIColor.fy.mainColor, for: .normal)
        button.titleLabel?.font = UIFont.fy.system_14
        button.fy.cornerRadius = 14
        button.backgroundColor = UIColor.fy.white
        button.layer.borderWidth = CGFloat.fy.px1
        button.layer.borderColor = UIColor.fy.mainColor.cgColor
        if let viewModel = viewModel as? MineUsersHeaderCellViewModel {
            button.rx.tap.bind(to: viewModel.signInEvent).disposed(by: rx.disposeBag)
        }
        return button
    }()

    lazy var dynamicNewsLabel: UILabel = {
        let label = BaseLabel.init()
        label.font = UIFont.fy.system_18
        label.textColor = UIColor.fy.white
        return label
    }()

    lazy var separatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.fy.line
        return line
    }()

    lazy var stackView: UIView = {
        let views = [Res.text("关注"), Res.text("粉丝"), Res.text("仓库")].map {
            // 修复：原代码数字 label 14pt，文字"关注/粉丝/仓库"15pt，字号反了
            // 应该是数字大、bold；文字小、regular
            // 美化：白卡背景，文字改用 title/gray_999999
            let numberLabel = BaseLabel(frame: .zero)
            numberLabel.textAlignment = .center
            numberLabel.textColor = UIColor.fy.title
            numberLabel.font = UIFont.fy.bold(20)  // 数字加大加粗

            let descLabel = BaseLabel(frame: .zero)
            descLabel.text = $0
            descLabel.textAlignment = .center
            descLabel.textColor = UIColor.fy.gray_999999
            descLabel.font = UIFont.fy.system_12  // 文字缩小

            let stack = UIStackView(arrangedSubviews: [numberLabel, descLabel])
            stack.axis = .vertical
            stack.spacing = 4
            stack.alignment = .center
            return stack
        }
        let stack = UIStackView(arrangedSubviews: views)
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        return stack
    }()

    override func setupConstraint() {
        // 美化：从全绿底改成"灰背景 + 白卡 + 顶部渐变条"
        backgroundColor = UIColor.fy.backgroundGray
        contentView.backgroundColor = UIColor.fy.backgroundGray

        contentView.addSubview(gradientBar)
        gradientBar.layer.insertSublayer(gradientLayer, at: 0)

        contentView.addSubview(cardView)
        cardView.addSubview(headerImageView)
        cardView.addSubview(nameLabel)
        cardView.addSubview(locationLabel)
        cardView.addSubview(signInButton)
        cardView.addSubview(separatorLine)
        cardView.addSubview(stackView)

        // 顶部渐变绿条：紧贴状态栏下沿，作为品牌色装饰
        gradientBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(cardView.snp.top).offset(-8)
        }

        // 卡片左右各留 12pt，上下间距 4pt，与 Discover 帖子卡一致
        cardView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-4)
        }

        headerImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(60)
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(headerImageView.snp.right).offset(15)
            make.top.equalTo(headerImageView.snp.top).offset(6)
            make.right.lessThanOrEqualTo(signInButton.snp.left).offset(-8)
        }
        locationLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
            make.right.equalTo(signInButton.snp.left).offset(-8)
        }
        signInButton.snp.makeConstraints { make in
            make.centerY.equalTo(headerImageView.snp.centerY)
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(64)
            make.height.equalTo(28)
        }
        separatorLine.snp.makeConstraints { make in
            make.top.equalTo(headerImageView.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
            make.height.equalTo(CGFloat.fy.px1)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(separatorLine.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-12)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // 让渐变跟随 gradientBar 真实尺寸
        gradientLayer.frame = gradientBar.bounds
    }
}
