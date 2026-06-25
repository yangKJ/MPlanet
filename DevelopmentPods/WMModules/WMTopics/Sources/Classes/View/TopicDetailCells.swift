//
//  TopicDetailCells.swift
//  WMTopics
//
//  Created by Condy on 2024/5/24.
//  帖子详情头部 + 评论区 cell
//

import UIKit
import FeatBox
import SnapKit
import RxSwift

// MARK: - 帖子详情头部 Cell

/// 帖子详情头部 Cell ViewModel
class TopicDetailHeaderCellViewModel: BaseTableViewCellViewModelable {
    var cellType: FeatBox.BaseTableViewCell.Type {
        TopicDetailHeaderCell.self
    }
}

/// 帖子详情头部 Cell：作者信息 + 标题 + 正文 + 配图 + 点赞数
class TopicDetailHeaderCell: BaseTableViewCell, HasDisposeBag {

    override var viewModel: BaseTableViewCellViewModelable? {
        didSet {
            guard let vm = viewModel as? TopicDetailHeaderCellViewModel,
                  let topic = vm.datasource as? Topic else {
                return
            }
            self.userNameLabel.text = topic.username
            self.timeLabel.text = topic.createTime
            self.titleLabel.text = topic.title
            self.contentLabel.text = topic.content
            self.avatarView.fy.setImage(with: topic.userAvatar)
            self.likeButton.setTitle("  点赞 \(topic.likeCount ?? 0)", for: .normal)
            self.commentButton.setTitle("  评论 \(topic.commentCount ?? 0)", for: .normal)
            self.rebuildImageGrid(with: topic.imageUrls ?? [])
        }
    }

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
        l.font = UIFont.fy.system_15
        return l
    }()

    private lazy var timeLabel: UILabel = {
        let l = BaseLabel()
        l.textColor = UIColor.fy.detailTitle
        l.font = UIFont.fy.system(11)
        l.textAlignment = .right
        return l
    }()

    private lazy var titleLabel: UILabel = {
        let l = BaseLabel()
        l.textColor = UIColor.fy.title
        l.font = UIFont.fy.bold(18)
        l.numberOfLines = 0
        return l
    }()

    private lazy var contentLabel: UILabel = {
        let l = BaseLabel()
        l.textColor = UIColor.fy.black_333333
        l.font = UIFont.fy.system_15
        l.numberOfLines = 0
        return l
    }()

    private lazy var imageGridView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.fy.clear
        return v
    }()

    private var imageViews: [UIImageView] = []
    private var imageGridHeightConstraint: Constraint?

    private lazy var likeButton: UIButton = {
        let b = BaseButton(type: .system)
        b.tintColor = UIColor.fy.detailTitle
        b.setImage(UIImage(systemName: "heart"), for: .normal)
        b.setTitleColor(UIColor.fy.detailTitle, for: .normal)
        b.titleLabel?.font = UIFont.fy.system_13
        b.imageEdgeInsets = UIEdgeInsets(top: 0, left: -2, bottom: 0, right: 2)
        b.titleEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
        return b
    }()

    private lazy var commentButton: UIButton = {
        let b = BaseButton(type: .system)
        b.tintColor = UIColor.fy.detailTitle
        b.setImage(UIImage(systemName: "bubble.right"), for: .normal)
        b.setTitleColor(UIColor.fy.detailTitle, for: .normal)
        b.titleLabel?.font = UIFont.fy.system_13
        b.imageEdgeInsets = UIEdgeInsets(top: 0, left: -2, bottom: 0, right: 2)
        b.titleEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
        return b
    }()

    override func setupConstraint() {
        contentView.backgroundColor = UIColor.fy.white
        contentView.addSubview(avatarView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(imageGridView)
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)

        avatarView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(44)
        }
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarView).offset(4)
            make.left.equalTo(avatarView.snp.right).offset(10)
        }
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(4)
            make.left.equalTo(userNameLabel)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(titleLabel)
            make.right.equalTo(titleLabel)
        }
        imageGridView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(12)
            make.left.equalTo(titleLabel)
            make.right.equalTo(titleLabel)
            self.imageGridHeightConstraint = make.height.equalTo(0).constraint
        }
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(imageGridView.snp.bottom).offset(12)
            make.left.equalTo(titleLabel)
            make.bottom.equalToSuperview().offset(-16)
            make.height.equalTo(28)
        }
        commentButton.snp.makeConstraints { make in
            make.centerY.equalTo(likeButton)
            make.left.equalTo(likeButton.snp.right).offset(20)
            make.height.equalTo(28)
        }
    }

    private func rebuildImageGrid(with urls: [String]) {
        imageViews.forEach { $0.removeFromSuperview() }
        imageViews.removeAll()

        if urls.isEmpty {
            imageGridHeightConstraint?.update(offset: 0)
            imageGridView.isHidden = true
            return
        }
        imageGridView.isHidden = false

        let count = urls.count
        let columns: Int
        let rows: Int
        if count == 1 {
            columns = 1
            rows = 1
        } else if count <= 3 {
            columns = count
            rows = 1
        } else if count <= 6 {
            columns = 3
            rows = Int(ceil(Double(count) / 3.0))
        } else {
            columns = 3
            rows = 3
        }
        let spacing: CGFloat = 6
        // 详情页去掉 24pt 边距，按 content 区域宽度计算
        let availableWidth = UIScreen.main.bounds.width - 32
        let itemSize: CGFloat = (availableWidth - spacing * CGFloat(columns - 1)) / CGFloat(columns)
        let totalHeight = CGFloat(rows) * itemSize + CGFloat(rows - 1) * spacing

        imageGridHeightConstraint?.update(offset: totalHeight)

        for i in 0..<count {
            let iv = BaseImageView()
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            iv.layer.cornerRadius = 6
            iv.backgroundColor = UIColor.fy.backgroundGray
            imageGridView.addSubview(iv)
            imageViews.append(iv)

            let row = i / columns
            let col = i % columns
            iv.snp.makeConstraints { make in
                make.left.equalTo(imageGridView).offset(CGFloat(col) * (itemSize + spacing))
                make.top.equalTo(imageGridView).offset(CGFloat(row) * (itemSize + spacing))
                make.width.height.equalTo(itemSize)
            }
            iv.fy.setImage(with: urls[i])
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
    }
}

// MARK: - 评论 Cell

/// 评论 Cell ViewModel
class CommentCellViewModel: BaseTableViewCellViewModelable {
    var cellType: FeatBox.BaseTableViewCell.Type {
        CommentCell.self
    }
}

/// 评论 Cell：左头像 + 右用户名/内容/时间
class CommentCell: BaseTableViewCell, HasDisposeBag {

    override var viewModel: BaseTableViewCellViewModelable? {
        didSet {
            guard let vm = viewModel as? CommentCellViewModel,
                  let comment = vm.datasource as? Comment else {
                return
            }
            self.userNameLabel.text = comment.username
            self.contentLabel.text = comment.content
            self.timeLabel.text = comment.createTime
            self.avatarView.fy.setImage(with: comment.userAvatar)
            self.likeButton.setTitle("  \(comment.likeCount ?? 0)", for: .normal)
        }
    }

    private lazy var avatarView: UIImageView = {
        let v = BaseImageView()
        v.contentMode = .scaleAspectFill
        v.layer.cornerRadius = 18
        v.layer.masksToBounds = true
        v.backgroundColor = UIColor.fy.backgroundGray
        return v
    }()

    private lazy var userNameLabel: UILabel = {
        let l = BaseLabel()
        l.textColor = UIColor.fy.title
        l.font = UIFont.fy.system_14
        return l
    }()

    private lazy var timeLabel: UILabel = {
        let l = BaseLabel()
        l.textColor = UIColor.fy.detailTitle
        l.font = UIFont.fy.system(11)
        l.textAlignment = .right
        return l
    }()

    private lazy var contentLabel: UILabel = {
        let l = BaseLabel()
        l.textColor = UIColor.fy.black_333333
        l.font = UIFont.fy.system_14
        l.numberOfLines = 0
        return l
    }()

    private lazy var likeButton: UIButton = {
        let b = BaseButton(type: .system)
        b.tintColor = UIColor.fy.detailTitle
        b.setImage(UIImage(systemName: "heart"), for: .normal)
        b.setTitleColor(UIColor.fy.detailTitle, for: .normal)
        b.titleLabel?.font = UIFont.fy.system(11)
        b.imageEdgeInsets = UIEdgeInsets(top: 0, left: -2, bottom: 0, right: 2)
        b.titleEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
        return b
    }()

    override func setupConstraint() {
        contentView.backgroundColor = UIColor.fy.white
        contentView.addSubview(avatarView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(likeButton)

        avatarView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(36)
        }
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarView)
            make.left.equalTo(avatarView.snp.right).offset(10)
            make.right.lessThanOrEqualTo(timeLabel.snp.left).offset(-8)
        }
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel)
            make.right.equalToSuperview().offset(-16)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(6)
            make.left.equalTo(userNameLabel)
            make.right.equalToSuperview().offset(-16)
        }
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(6)
            make.left.equalTo(userNameLabel)
            make.bottom.equalToSuperview().offset(-12)
            make.height.equalTo(20)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.image = nil
        userNameLabel.text = nil
        timeLabel.text = nil
        contentLabel.text = nil
        likeButton.setTitle(nil, for: .normal)
    }
}
