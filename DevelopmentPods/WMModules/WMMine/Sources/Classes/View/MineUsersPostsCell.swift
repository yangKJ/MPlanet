//
//  MineUsersPostsCell.swift
//  WMMine
//
//  Created by Condy on 2023/6/6.
//  帖子流 cell：头像 + 用户名/时间 + 标题 + 内容 + 配图 + 点赞/评论
//

import UIKit
import FeatBox
import SnapKit
import RxSwift

class MineUsersPostsCellViewModel: BaseTableViewCellViewModelable {
    var cellType: FeatBox.BaseTableViewCell.Type {
        MineUsersPostsCell.self
    }
    var isFirst: Bool = false
    var isLast: Bool = false
}

/// 帖子流 cell：完整社交风格（头像 / 标题 / 内容 / 配图 / 操作栏）
class MineUsersPostsCell: BaseTableViewCell, HasDisposeBag {

    override var viewModel: BaseTableViewCellViewModelable? {
        didSet {
            guard let viewModel = viewModel as? MineUsersPostsCellViewModel,
                  let post = viewModel.datasource as? MinePostsDetail else {
                return
            }
            self.titleLabel.text = post.title
            self.contentLabel.text = post.content
            self.timeLabel.text = post.createTime ?? ""
            self.userNameLabel.text = post.userName ?? ""
            self.avatarView.fy.setImage(with: post.userAvatar, placeholder: Placeholder.webImage)
            self.likeButton.setTitle("  \(post.likeCount ?? 0)", for: .normal)
            self.commentButton.setTitle("  \(post.commentCount ?? 0)", for: .normal)
            // 配图：0 张隐藏；1-3 张按 grid 排
            self.rebuildImageGrid(with: post.imageUrls ?? [])
        }
    }

    // MARK: - 头部（头像 + 用户名 + 时间）

    private lazy var avatarView: UIImageView = {
        let v = BaseImageView()
        v.contentMode = .scaleAspectFill
        v.layer.cornerRadius = 22
        v.layer.masksToBounds = true
        v.backgroundColor = UIColor.fy.backgroundGray
        return v
    }()

    private lazy var userNameLabel: UILabel = {
        let l = BaseLabel()
        l.textColor = UIColor.fy.title
        l.font = UIFont.fy.bold(15)
        return l
    }()

    private lazy var timeLabel: UILabel = {
        let l = BaseLabel()
        l.textColor = UIColor.fy.detailTitle
        l.font = UIFont.fy.system(12)
        l.textAlignment = .right
        return l
    }()

    // MARK: - 中部（标题 + 内容）

    private lazy var titleLabel: UILabel = {
        let l = BaseLabel()
        l.textColor = UIColor.fy.title
        l.font = UIFont.fy.bold(17)
        l.numberOfLines = 2
        return l
    }()

    private lazy var contentLabel: UILabel = {
        let l = BaseLabel()
        l.textColor = UIColor.fy.black_333333
        l.font = UIFont.fy.system(15)
        l.numberOfLines = 3
        l.lineBreakMode = .byTruncatingTail
        return l
    }()

    // MARK: - 配图 grid

    private lazy var imageGridView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.fy.clear
        return v
    }()

    private var imageViews: [UIImageView] = []
    private var imageGridHeightConstraint: Constraint?

    // MARK: - 底部操作栏（点赞 / 评论）

    private lazy var likeButton: UIButton = {
        let b = BaseButton(type: .system)
        b.tintColor = UIColor.fy.detailTitle
        b.setImage(UIImage(systemName: "heart"), for: .normal)
        b.setTitleColor(UIColor.fy.detailTitle, for: .normal)
        b.titleLabel?.font = UIFont.fy.system(13)
        b.imageEdgeInsets = UIEdgeInsets(top: 0, left: -2, bottom: 0, right: 2)
        b.titleEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
        return b
    }()

    private lazy var commentButton: UIButton = {
        let b = BaseButton(type: .system)
        b.tintColor = UIColor.fy.detailTitle
        b.setImage(UIImage(systemName: "bubble.right"), for: .normal)
        b.setTitleColor(UIColor.fy.detailTitle, for: .normal)
        b.titleLabel?.font = UIFont.fy.system(13)
        b.imageEdgeInsets = UIEdgeInsets(top: 0, left: -2, bottom: 0, right: 2)
        b.titleEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
        return b
    }()

    // MARK: - 布局

    override func setupConstraint() {
        // 美化：与 Discover 一致，外层灰背景 + 内层白卡
        self.backgroundColor = UIColor.fy.backgroundGray
        self.contentView.backgroundColor = UIColor.fy.backgroundGray

        // 白卡容器：把 avatar/标题/内容/操作栏包到圆角白卡中
        let cardView = UIView()
        cardView.backgroundColor = UIColor.fy.white
        cardView.layer.cornerRadius = 12
        cardView.layer.masksToBounds = true
        self.contentView.addSubview(cardView)

        // 配图 grid 圆角
        imageGridView.layer.cornerRadius = 8
        imageGridView.layer.masksToBounds = true

        // 所有内容移到 cardView
        cardView.addSubview(avatarView)
        cardView.addSubview(userNameLabel)
        cardView.addSubview(timeLabel)
        cardView.addSubview(titleLabel)
        cardView.addSubview(contentLabel)
        cardView.addSubview(imageGridView)
        cardView.addSubview(likeButton)
        cardView.addSubview(commentButton)

        // 卡片与 cell 边缘留 4pt 上下 + 12pt 左右，形成 8pt 卡片间距
        cardView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }

        avatarView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.left.equalToSuperview().offset(14)
            make.width.height.equalTo(44)
        }
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarView).offset(2)
            make.left.equalTo(avatarView.snp.right).offset(10)
            make.right.lessThanOrEqualTo(timeLabel.snp.left).offset(-8)
        }
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel)
            make.right.equalToSuperview().offset(-14)
            make.width.lessThanOrEqualTo(120)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarView.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(14)
            make.right.equalToSuperview().offset(-14)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.left.equalTo(titleLabel)
            make.right.equalTo(titleLabel)
        }
        imageGridView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.left.equalTo(titleLabel)
            make.right.equalTo(titleLabel)
            self.imageGridHeightConstraint = make.height.equalTo(0).constraint
        }
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(imageGridView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(14)
            make.bottom.equalToSuperview().offset(-12)
            make.height.equalTo(24)
        }
        commentButton.snp.makeConstraints { make in
            make.centerY.equalTo(likeButton)
            make.left.equalTo(likeButton.snp.right).offset(20)
            make.height.equalTo(24)
        }
    }

    /// 重建配图 grid（1-3 张）
    private func rebuildImageGrid(with urls: [String]) {
        imageViews.forEach { $0.removeFromSuperview() }
        imageViews.removeAll()

        if urls.isEmpty {
            imageGridHeightConstraint?.update(offset: 0)
            imageGridView.isHidden = true
            return
        }
        imageGridView.isHidden = false

        let count = min(urls.count, 3)
        let columns: Int
        if count == 1 {
            columns = 1
        } else if count <= 3 {
            columns = count
        } else {
            columns = 3
        }
        let availableWidth = UIScreen.main.bounds.width - 24 - 28 // 美化：减去卡片外侧 12pt+12pt + 内部内边距 14pt+14pt
        let spacing: CGFloat = 6
        let itemSize: CGFloat = (availableWidth - spacing * CGFloat(columns - 1)) / CGFloat(columns)
        let totalHeight = itemSize  // 单行

        imageGridHeightConstraint?.update(offset: totalHeight)

        for i in 0..<count {
            let iv = BaseImageView()
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            iv.backgroundColor = UIColor.fy.backgroundGray
            imageGridView.addSubview(iv)
            imageViews.append(iv)

            let col = i % columns
            iv.snp.makeConstraints { make in
                make.left.equalTo(imageGridView).offset(CGFloat(col) * (itemSize + spacing))
                make.top.bottom.equalToSuperview()
                make.width.height.equalTo(itemSize)
            }
            iv.fy.setImage(with: urls[i], placeholder: Placeholder.webImage)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.image = nil
        imageViews.forEach { $0.image = nil }
        userNameLabel.text = nil
        timeLabel.text = nil
        titleLabel.text = nil
        contentLabel.text = nil
        likeButton.setTitle(nil, for: .normal)
        commentButton.setTitle(nil, for: .normal)
    }
}
