//
//  ChatSessionCell.swift
//  WMChat
//
//  Created by Condy on 2024/5/24.
//  会话 cell：左 50pt 圆形头像 + 中用户名/最后消息 + 右时间/未读红点
//

import UIKit
import FeatBox
import SnapKit

/// 会话 Cell ViewModel
class ChatSessionCellViewModel: BaseTableViewCellViewModelable {
    var cellType: FeatBox.BaseTableViewCell.Type {
        ChatSessionCell.self
    }
}

/// 会话 Cell
class ChatSessionCell: BaseTableViewCell, HasDisposeBag {

    override var viewModel: BaseTableViewCellViewModelable? {
        didSet {
            guard let vm = viewModel as? ChatSessionCellViewModel,
                  let session = vm.datasource as? ChatSession else {
                return
            }
            self.userNameLabel.text = session.username
            self.lastMessageLabel.text = session.lastMessage
            self.timeLabel.text = session.lastTime
            self.avatarView.fy.setImage(with: session.avatar)
            // 未读数：>0 显示，=0 隐藏
            let unread = session.unreadCount ?? 0
            if unread > 0 {
                self.unreadBadge.isHidden = false
                self.unreadBadge.text = unread > 99 ? "99+" : "\(unread)"
            } else {
                self.unreadBadge.isHidden = true
            }
        }
    }

    private lazy var avatarView: UIImageView = {
        let v = BaseImageView()
        v.contentMode = .scaleAspectFill
        v.layer.cornerRadius = 28
        v.layer.masksToBounds = true
        v.backgroundColor = UIColor.fy.backgroundGray
        // 美化：头像加浅色边框
        v.layer.borderColor = UIColor.fy.line.cgColor
        v.layer.borderWidth = 0.5
        return v
    }()

    private lazy var userNameLabel: UILabel = {
        let l = BaseLabel()
        l.textColor = UIColor.fy.title
        l.font = UIFont.fy.bold(16)
        return l
    }()

    private lazy var lastMessageLabel: UILabel = {
        let l = BaseLabel()
        l.textColor = UIColor.fy.detailTitle
        l.font = UIFont.fy.system(14)
        l.numberOfLines = 1
        l.lineBreakMode = .byTruncatingTail
        return l
    }()

    private lazy var timeLabel: UILabel = {
        let l = BaseLabel()
        l.textColor = UIColor.fy.detailTitle
        l.font = UIFont.fy.system(11)
        l.textAlignment = .right
        return l
    }()

    /// 未读红点 badge：圆角 9pt，systemRed 背景
    private lazy var unreadBadge: UILabel = {
        let l = UILabel()
        l.textColor = .white
        l.font = UIFont.fy.bold(11)
        l.textAlignment = .center
        l.backgroundColor = UIColor.fy.red
        l.layer.cornerRadius = 9
        l.layer.masksToBounds = true
        l.isHidden = true
        // 美化：红点阴影
        l.layer.shadowColor = UIColor.fy.red.cgColor
        l.layer.shadowOpacity = 0.3
        l.layer.shadowRadius = 3
        l.layer.shadowOffset = CGSize(width: 0, height: 1)
        return l
    }()

    override func setupConstraint() {
        contentView.backgroundColor = UIColor.fy.white
        contentView.addSubview(avatarView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(lastMessageLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(unreadBadge)

        // 美化：cell 高度从默认 → 70pt
        let cellHeight: CGFloat = 70
        contentView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(cellHeight)
        }

        // 头像 50pt → 56pt（更显眼）
        avatarView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(56)
        }
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarView).offset(2)
            make.left.equalTo(avatarView.snp.right).offset(12)
            make.right.lessThanOrEqualTo(timeLabel.snp.left).offset(-8)
        }
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel)
            make.right.equalToSuperview().offset(-16)
            make.width.lessThanOrEqualTo(80)
        }
        lastMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(6)
            make.left.equalTo(userNameLabel)
            make.right.lessThanOrEqualTo(unreadBadge.snp.left).offset(-8)
        }
        unreadBadge.snp.makeConstraints { make in
            make.centerY.equalTo(lastMessageLabel)
            make.right.equalToSuperview().offset(-16)
            make.width.greaterThanOrEqualTo(18)
            make.height.equalTo(18)
        }
    }

    // 美化：cell 按下高亮反馈
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.15) {
                self.contentView.backgroundColor = self.isHighlighted ? UIColor.fy.backgroundGray : UIColor.fy.white
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.image = nil
        userNameLabel.text = nil
        lastMessageLabel.text = nil
        timeLabel.text = nil
        unreadBadge.isHidden = true
        unreadBadge.text = nil
    }
}
