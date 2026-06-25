//
//  TopicCell.swift
//  WMTopics
//
//  Created by Condy on 2024/5/24.
//  帖子流 cell：左 50pt 圆形头像 + 右用户名/时间/标题/内容/配图 + 底部点赞/评论/分享
//

import UIKit
import FeatBox
import SnapKit
import RxSwift

/// 帖子流 Cell ViewModel
class TopicCellViewModel: BaseTableViewCellViewModelable {
    var cellType: FeatBox.BaseTableViewCell.Type {
        TopicCell.self
    }
}

/// 帖子流 Cell
class TopicCell: BaseTableViewCell, HasDisposeBag {

    override var viewModel: BaseTableViewCellViewModelable? {
        didSet {
            guard let vm = viewModel as? TopicCellViewModel,
                  let topic = vm.datasource as? Topic else {
                return
            }
            self.userNameLabel.text = topic.username
            self.timeLabel.text = topic.createTime
            self.titleLabel.text = topic.title
            self.contentLabel.text = topic.content
            self.avatarView.fy.setImage(with: topic.userAvatar)
            self.likeButton.setTitle("  \(topic.likeCount ?? 0)", for: .normal)
            self.commentButton.setTitle("  \(topic.commentCount ?? 0)", for: .normal)
            self.rebuildImageGrid(with: topic.imageUrls ?? [])
        }
    }

    // MARK: - 子视图

    private lazy var avatarView: UIImageView = {
        let v = BaseImageView()
        v.contentMode = .scaleAspectFill
        v.layer.cornerRadius = 24
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
        l.font = UIFont.fy.system(11)
        l.textAlignment = .right
        return l
    }()

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

    private lazy var imageGridView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.fy.clear
        return v
    }()

    private var imageViews: [UIImageView] = []

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

    private lazy var commentButton: UIButton = {
        let b = BaseButton(type: .system)
        b.tintColor = UIColor.fy.detailTitle
        b.setImage(UIImage(systemName: "bubble.right"), for: .normal)
        b.setTitleColor(UIColor.fy.detailTitle, for: .normal)
        b.titleLabel?.font = UIFont.fy.system(11)
        b.imageEdgeInsets = UIEdgeInsets(top: 0, left: -2, bottom: 0, right: 2)
        b.titleEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
        return b
    }()

    private lazy var shareButton: UIButton = {
        let b = BaseButton(type: .system)
        b.tintColor = UIColor.fy.detailTitle
        b.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        b.setTitleColor(UIColor.fy.detailTitle, for: .normal)
        b.titleLabel?.font = UIFont.fy.system(11)
        b.imageEdgeInsets = UIEdgeInsets(top: 0, left: -2, bottom: 0, right: 2)
        b.titleEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
        return b
    }()

    // 配图 grid 高度（用于 cell 自适应）
    private var imageGridHeightConstraint: Constraint?

    override func setupConstraint() {
        // 修复：cell 圆角白卡 + 阴影 + 上间距，让 cell 视觉更精致
        contentView.backgroundColor = UIColor.fy.white
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.fy.black.cgColor
        contentView.layer.shadowOpacity = 0.06
        contentView.layer.shadowRadius = 6
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.addSubview(avatarView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(imageGridView)
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(shareButton)

        // 配图 grid 圆角加大
        imageGridView.layer.cornerRadius = 8
        imageGridView.layer.masksToBounds = true

        // 头像尺寸 50pt → 48pt 圆形
        avatarView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.left.equalToSuperview().offset(14)
            make.width.height.equalTo(48)
        }
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarView).offset(4)
            make.left.equalTo(avatarView.snp.right).offset(10)
            make.right.lessThanOrEqualTo(timeLabel.snp.left).offset(-8)
        }
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel)
            make.right.equalToSuperview().offset(-12)
            make.width.lessThanOrEqualTo(120)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.left.equalTo(titleLabel)
            make.right.equalTo(titleLabel)
        }
        imageGridView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.left.equalTo(contentLabel)
            make.right.equalTo(contentLabel)
            self.imageGridHeightConstraint = make.height.equalTo(0).constraint
        }
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(imageGridView.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
            make.height.equalTo(24)
        }
        commentButton.snp.makeConstraints { make in
            make.centerY.equalTo(likeButton)
            make.left.equalTo(likeButton.snp.right).offset(20)
            make.height.equalTo(24)
        }
        shareButton.snp.makeConstraints { make in
            make.centerY.equalTo(likeButton)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(24)
        }
    }

    /// 重建配图 grid（1-9 张自适应）
    private func rebuildImageGrid(with urls: [String]) {
        // 清空旧视图
        imageViews.forEach { $0.removeFromSuperview() }
        imageViews.removeAll()

        if urls.isEmpty {
            imageGridHeightConstraint?.update(offset: 0)
            imageGridView.isHidden = true
            return
        }
        imageGridView.isHidden = false

        let count = urls.count
        // 1 张：大图；2-3 张：一行；4-9 张：2-3 行
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
        let itemSize: CGFloat = (UIScreen.main.bounds.width - 24 - 12 - 6 * CGFloat(columns - 1)) / CGFloat(columns)
        let spacing: CGFloat = 6
        let totalHeight = CGFloat(rows) * itemSize + CGFloat(rows - 1) * spacing

        imageGridHeightConstraint?.update(offset: totalHeight)
        imageGridView.snp.updateConstraints { make in
            make.height.equalTo(totalHeight)
        }

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
        likeButton.setTitle(nil, for: .normal)
        commentButton.setTitle(nil, for: .normal)
    }
}
