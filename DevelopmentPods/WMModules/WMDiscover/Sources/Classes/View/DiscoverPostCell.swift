//
//  DiscoverPostCell.swift
//  WMDiscover
//
//  Created by UI Designer on 2024/5/24.
//  最新帖子流 cell：圆头像 + 用户名/时间 + 标题 + 缩略图 + 操作栏
//

import UIKit
import FeatBox
import SnapKit

/// 帖子流 cell viewModel
class DiscoverPostCellViewModel: BaseTableViewCellViewModelable {

    var cellType: FeatBox.BaseTableViewCell.Type {
        DiscoverPostCell.self
    }
}

/// 帖子 cell
class DiscoverPostCell: BaseTableViewCell, HasDisposeBag {

    /// 美化：外层阴影容器（不裁切）—— 给 cardView 投影
    private let shadowContainer: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.fy.clear
        v.layer.shadowColor = UIColor.fy.black.cgColor
        v.layer.shadowOpacity = 0.06
        v.layer.shadowRadius = 8
        v.layer.shadowOffset = CGSize(width: 0, height: 2)
        return v
    }()

    /// 美化：内层白卡（裁切圆角）—— 承载所有内容子 view
    private let cardView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.fy.white
        v.layer.cornerRadius = 14
        v.layer.masksToBounds = true
        return v
    }()

    private let avatarView: BaseImageView = {
        let v = BaseImageView()
        v.contentMode = .scaleAspectFill
        v.layer.cornerRadius = 22
        v.layer.masksToBounds = true
        v.backgroundColor = UIColor.fy.backgroundGray
        // 美化：1pt 主色绿描边，让头像在卡片上更跳
        v.layer.borderColor = UIColor.fy.mainColor.withAlphaComponent(0.18).cgColor
        v.layer.borderWidth = 1
        return v
    }()

    private let userNameLabel: BaseLabel = {
        let l = BaseLabel()
        l.textColor = UIColor.fy.title
        l.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return l
    }()

    private let timeLabel: BaseLabel = {
        let l = BaseLabel()
        l.textColor = UIColor.fy.gray_B0B0B0
        l.font = UIFont.fy.system_12
        return l
    }()

    /// 标题（加粗，14-16pt）
    private let contentLabel: BaseLabel = {
        let l = BaseLabel()
        l.textColor = UIColor.fy.title
        l.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        l.numberOfLines = 3
        l.lineBreakMode = .byTruncatingTail
        return l
    }()

    private let photoView: BaseImageView = {
        let v = BaseImageView()
        v.contentMode = .scaleAspectFill
        v.layer.cornerRadius = 12
        v.layer.masksToBounds = true
        v.backgroundColor = UIColor.fy.backgroundGray
        return v
    }()

    private let likeButton: UIButton = {
        let b = UIButton(type: .system)
        b.tintColor = UIColor.fy.gray_999999
        b.setImage(UIImage(systemName: "heart"), for: .normal)
        b.setTitleColor(UIColor.fy.gray_999999, for: .normal)
        b.titleLabel?.font = UIFont.fy.system_12
        b.imageEdgeInsets = UIEdgeInsets(top: 0, left: -3, bottom: 0, right: 3)
        b.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
        return b
    }()

    private let commentButton: UIButton = {
        let b = UIButton(type: .system)
        b.tintColor = UIColor.fy.gray_999999
        b.setImage(UIImage(systemName: "bubble.right"), for: .normal)
        b.setTitleColor(UIColor.fy.gray_999999, for: .normal)
        b.titleLabel?.font = UIFont.fy.system_12
        b.imageEdgeInsets = UIEdgeInsets(top: 0, left: -3, bottom: 0, right: 3)
        b.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
        return b
    }()

    private let shareButton: UIButton = {
        let b = UIButton(type: .system)
        b.tintColor = UIColor.fy.gray_999999
        b.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        b.setTitleColor(UIColor.fy.gray_999999, for: .normal)
        b.titleLabel?.font = UIFont.fy.system_12
        b.setTitle(" 分享", for: .normal)
        b.imageEdgeInsets = UIEdgeInsets(top: 0, left: -3, bottom: 0, right: 3)
        b.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
        return b
    }()

    override var viewModel: BaseTableViewCellViewModelable? {
        didSet {
            guard let post = viewModel?.datasource as? DiscoverPost else { return }
            self.userNameLabel.text = post.userName
            self.timeLabel.text = post.createTime
            self.contentLabel.text = post.content
            self.avatarView.fy.setImage(with: post.avatarPath)
            // 只有当 imagePath 不为空时显示缩略图
            if let path = post.imagePath, !path.isEmpty {
                self.photoView.isHidden = false
                self.photoView.snp.updateConstraints { make in
                    make.height.equalTo(160)
                }
                self.photoView.fy.setImage(with: path)
            } else {
                self.photoView.isHidden = true
                self.photoView.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
            }
            self.likeButton.setTitle("  \(post.likeCount ?? 0)", for: .normal)
            self.commentButton.setTitle("  \(post.commentCount ?? 0)", for: .normal)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.avatarView.image = nil
        self.photoView.image = nil
        self.userNameLabel.text = nil
        self.timeLabel.text = nil
        self.contentLabel.text = nil
        self.likeButton.setTitle(nil, for: .normal)
        self.commentButton.setTitle(nil, for: .normal)
    }

    override func setupConstraint() {
        self.backgroundColor = UIColor.fy.clear
        self.contentView.backgroundColor = UIColor.fy.clear

        // 美化：双层结构 —— shadowContainer(不裁切,带阴影) + cardView(裁切,白底圆角)
        shadowContainer.addSubview(cardView)
        self.contentView.addSubview(shadowContainer)
        cardView.addSubview(avatarView)
        cardView.addSubview(userNameLabel)
        cardView.addSubview(timeLabel)
        cardView.addSubview(contentLabel)
        cardView.addSubview(photoView)
        cardView.addSubview(likeButton)
        cardView.addSubview(commentButton)
        cardView.addSubview(shareButton)

        // cell 上下 4pt 留白，让卡片之间形成 8pt 间距
        shadowContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        avatarView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(12)
            make.width.height.equalTo(44)
        }
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarView).offset(2)
            make.left.equalTo(avatarView.snp.right).offset(10)
            make.right.lessThanOrEqualToSuperview().offset(-12)
        }
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(4)
            make.left.equalTo(userNameLabel)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarView.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }
        photoView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(160)
        }
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(photoView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
            make.height.equalTo(28)
        }
        commentButton.snp.makeConstraints { make in
            make.centerY.equalTo(likeButton)
            make.left.equalTo(likeButton.snp.right).offset(20)
            make.height.equalTo(28)
        }
        shareButton.snp.makeConstraints { make in
            make.centerY.equalTo(likeButton)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(28)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // 美化：给 shadowContainer 一个 explicit shadow path，
        // 形状跟着 cardView 圆角走，cell 复用时不用每帧重算离屏渲染，
        // 滚动性能更稳
        let bounds = shadowContainer.bounds
        if bounds.width > 0, bounds.height > 0 {
            let path = UIBezierPath(
                roundedRect: bounds,
                cornerRadius: 14
            ).cgPath
            shadowContainer.layer.shadowPath = path
        }
    }
}
