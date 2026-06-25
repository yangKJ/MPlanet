//
//  LearnRankingBarCell.swift
//  WMLearn
//
//  Created by Condy on 2024/6/24.
//  美化说明：白卡 + CALayer 渐变柱 + 当前用户高亮 + spring 动画
//

import UIKit
import FeatBox
import Mediator
import SnapKit

/// 排行榜柱状图 Cell ViewModel
class LearnRankingBarCellViewModel: BaseTableViewCellViewModelable {
    var cellType: FeatBox.BaseTableViewCell.Type {
        LearnRankingBarCell.self
    }
}

/// 排行榜柱状图 Cell
/// 横向展示前 N 名用户分数对比
class LearnRankingBarCell: BaseTableViewCell, HasDisposeBag {

    override var viewModel: BaseTableViewCellViewModelable? {
        didSet {
            guard let vm = viewModel as? LearnRankingBarCellViewModel,
                  let list = vm.datasource as? [LearnRanking] else {
                return
            }
            self.dataSourceRelay.accept(list)
        }
    }

    private let dataSourceRelay = BehaviorRelay<[LearnRanking]>(value: [])

    /// 横向滚动容器（用户多时支持滑动）
    private let scrollView: UIScrollView = {
        let s = UIScrollView()
        s.showsHorizontalScrollIndicator = false
        s.alwaysBounceHorizontal = true
        s.backgroundColor = UIColor.fy.clear
        return s
    }()

    private let containerView = UIView()

    private var barViews: [LearnRankingBarView] = []

    override func setupConstraint() {
        contentView.backgroundColor = UIColor.fy.white
        contentView.addSubview(scrollView)
        scrollView.addSubview(containerView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16))
        }

        dataSourceRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] list in
                self?.rebuildBars(with: list)
            }).disposed(by: rx.disposeBag)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // 收到 layout 后再重新布局一次（保证首屏 / 旋转后柱子高度正确）
        if !barViews.isEmpty {
            layoutBars()
        }
    }

    private func rebuildBars(with list: [LearnRanking]) {
        // 清空旧柱子
        barViews.forEach { $0.removeFromSuperview() }
        barViews.removeAll()

        for (idx, item) in list.enumerated() {
            let bar = LearnRankingBarView()
            bar.rank = item.rank ?? (idx + 1)
            bar.name = item.name ?? "-"
            bar.score = item.score ?? 0
            bar.isCurrentUser = item.isCurrentUser ?? false
            bar.onTap = { [weak self] in
                // 点击柱子进入视频赔价榜
                if let vc = Mediator.performTarget(
                    "LearnTarget",
                    action: "Action_videoRankingViewController:",
                    module: "WMLearn",
                    params: ["categoryId": 1]
                ) as? UIViewController {
                    UIViewController.fy.currentViewController()?
                        .navigationController?
                        .pushViewController(vc, animated: true)
                }
                _ = self
            }
            containerView.addSubview(bar)
            barViews.append(bar)
        }
        setNeedsLayout()
        layoutIfNeeded()
    }

    private func layoutBars() {
        guard !barViews.isEmpty else { return }
        let count = CGFloat(barViews.count)
        let spacing: CGFloat = 12
        let barWidth: CGFloat = 36
        let totalWidth = max(CGFloat(barViews.count) * (barWidth + spacing), containerView.bounds.width)
        let maxBarHeight: CGFloat = containerView.bounds.height - 64 // 预留底部名称 + 顶部分数
        containerView.frame = CGRect(x: 0, y: 0, width: totalWidth, height: containerView.bounds.height)
        scrollView.contentSize = CGSize(width: totalWidth, height: containerView.bounds.height)
        for (idx, bar) in barViews.enumerated() {
            let x = CGFloat(idx) * (barWidth + spacing) + spacing
            bar.frame = CGRect(x: x, y: 0, width: barWidth, height: containerView.bounds.height)
            bar.maxBarHeight = maxBarHeight
            bar.layoutIfNeeded()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        dataSourceRelay.accept([])
        barViews.forEach { $0.removeFromSuperview() }
        barViews.removeAll()
    }
}

/// 单根柱状图（用户名 + 渐变柱 + 分数 + 排行徽章）
class LearnRankingBarView: UIView {

    var rank: Int = 0
    var name: String = ""
    var score: Int = 0
    var isCurrentUser: Bool = false
    var maxBarHeight: CGFloat = 140

    var onTap: (() -> Void)?

    private let nameLabel: UILabel = {
        let label = BaseLabel()
        label.textColor = UIColor.fy.detailTitle
        label.font = UIFont.fy.system(11)
        label.textAlignment = .center
        return label
    }()

    private let scoreLabel: UILabel = {
        let label = BaseLabel()
        label.textColor = UIColor.fy.mainColor
        label.font = UIFont.fy.bold(13)
        label.textAlignment = .center
        return label
    }()

    private let barView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()

    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.fy.mainColor.cgColor,
            UIColor.fy.lightGreen.withAlphaComponent(0.85).cgColor
        ]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 1)
        return layer
    }()

    /// 排行徽章（金/银/铜 或当前用户红色）
    private let rankBadge: BaseLabel = {
        let l = BaseLabel()
        l.textColor = UIColor.fy.white
        l.font = UIFont.fy.bold(10)
        l.textAlignment = .center
        l.layer.cornerRadius = 9
        l.layer.masksToBounds = true
        return l
    }()

    /// 当前用户高亮边框
    private let highlightRing: UIView = {
        let v = UIView()
        v.layer.borderWidth = 2
        v.layer.borderColor = UIColor.systemRed.cgColor
        v.layer.cornerRadius = 10
        v.layer.masksToBounds = true
        v.backgroundColor = UIColor.fy.clear
        v.isUserInteractionEnabled = false
        return v
    }()

    private var barHeightConstraint: Constraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        addSubview(nameLabel)
        addSubview(scoreLabel)
        addSubview(barView)
        addSubview(highlightRing)
        addSubview(rankBadge)
        barView.layer.addSublayer(gradientLayer)

        nameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-8)
            make.height.equalTo(28)
        }
        scoreLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(18)
        }
        barView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(nameLabel.snp.top).offset(-4)
            make.width.equalToSuperview().multipliedBy(0.65)
            self.barHeightConstraint = make.height.equalTo(20).constraint
        }
        highlightRing.snp.makeConstraints { make in
            make.edges.equalTo(barView)
        }
        rankBadge.snp.makeConstraints { make in
            make.centerX.equalTo(barView)
            make.top.equalTo(barView).offset(-6)
            make.width.equalTo(20)
            make.height.equalTo(18)
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        isUserInteractionEnabled = true
        addGestureRecognizer(tap)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = barView.bounds
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        updateBar()
    }

    private func updateBar() {
        let ratio = max(0, min(1, CGFloat(score) / 100.0))
        let height = max(8, ratio * maxBarHeight)
        barHeightConstraint?.update(offset: height)
        scoreLabel.text = "\(score)"
        nameLabel.text = name
        nameLabel.numberOfLines = 2

        // 排行徽章颜色
        rankBadge.text = "\(rank)"
        switch rank {
        case 1:
            rankBadge.backgroundColor = UIColor(red: 1.0, green: 0.78, blue: 0.20, alpha: 1.0) // 金
        case 2:
            rankBadge.backgroundColor = UIColor(red: 0.75, green: 0.75, blue: 0.78, alpha: 1.0) // 银
        case 3:
            rankBadge.backgroundColor = UIColor(red: 0.80, green: 0.50, blue: 0.20, alpha: 1.0) // 铜
        default:
            rankBadge.backgroundColor = UIColor.fy.mainColor
        }

        // 当前用户高亮（红色边框 + 1.15x 缩放）
        if isCurrentUser {
            highlightRing.isHidden = false
            nameLabel.textColor = UIColor.fy.mainColor
            nameLabel.font = UIFont.fy.bold(11)
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.6,
                           initialSpringVelocity: 0.5,
                           options: [.allowUserInteraction],
                           animations: {
                self.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            }, completion: nil)
        } else {
            highlightRing.isHidden = true
            nameLabel.textColor = UIColor.fy.detailTitle
            nameLabel.font = UIFont.fy.system(11)
            self.transform = .identity
        }
    }

    @objc private func handleTap() {
        // 点击时 spring 反馈
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.92, y: 0.92).concatenating(self.isCurrentUser ? CGAffineTransform(scaleX: 1.15, y: 1.15) : .identity)
        }, completion: { _ in
            UIView.animate(withDuration: 0.4,
                           delay: 0,
                           usingSpringWithDamping: 0.55,
                           initialSpringVelocity: 0.5,
                           options: [],
                           animations: {
                if self.isCurrentUser {
                    self.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                } else {
                    self.transform = .identity
                }
            })
        })
        onTap?()
    }
}

/// 排行榜列表 Cell ViewModel
class LearnRankingListCellViewModel: BaseTableViewCellViewModelable {
    var cellType: FeatBox.BaseTableViewCell.Type {
        LearnRankingListCell.self
    }
}

/// 排行榜列表 Cell（完整榜单中的单行）
class LearnRankingListCell: BaseTableViewCell, HasDisposeBag {

    override var viewModel: BaseTableViewCellViewModelable? {
        didSet {
            guard let vm = viewModel as? LearnRankingListCellViewModel,
                  let item = vm.datasource as? LearnRanking else {
                return
            }
            let rank = item.rank ?? 0
            rankLabel.text = "\(rank)"
            // 前三名特殊颜色（金/银/铜）
            switch rank {
            case 1:
                rankLabel.textColor = UIColor(red: 1.0, green: 0.78, blue: 0.20, alpha: 1.0)
            case 2:
                rankLabel.textColor = UIColor(red: 0.55, green: 0.55, blue: 0.60, alpha: 1.0)
            case 3:
                rankLabel.textColor = UIColor(red: 0.80, green: 0.50, blue: 0.20, alpha: 1.0)
            default:
                rankLabel.textColor = UIColor.fy.mainColor
            }
            nameLabel.text = item.name
            scoreLabel.text = "\(item.score ?? 0) 分"
            avatarImageView.fy.setImage(with: item.avatar)
            if item.isCurrentUser == true {
                contentView.backgroundColor = UIColor.fy.mainColor.withAlphaComponent(0.08)
                nameLabel.textColor = UIColor.fy.mainColor
                nameLabel.font = UIFont.fy.bold(15)
                highlightIcon.isHidden = false
            } else {
                contentView.backgroundColor = UIColor.fy.white
                nameLabel.textColor = UIColor.fy.title
                nameLabel.font = UIFont.fy.system_15
                highlightIcon.isHidden = true
            }
        }
    }

    private lazy var avatarImageView: UIImageView = {
        let view = BaseImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 22
        view.backgroundColor = UIColor.fy.gray_F3F3F3
        return view
    }()

    private lazy var rankLabel: UILabel = {
        let label = BaseLabel()
        label.textColor = UIColor.fy.mainColor
        label.font = UIFont.fy.bold(16)
        label.textAlignment = .center
        return label
    }()

    private lazy var nameLabel: UILabel = {
        let label = BaseLabel()
        label.textColor = UIColor.fy.title
        label.font = UIFont.fy.system_15
        return label
    }()

    private lazy var scoreLabel: UILabel = {
        let label = BaseLabel()
        label.textColor = UIColor.fy.detailTitle
        label.font = UIFont.fy.system_13
        label.textAlignment = .right
        return label
    }()

    /// 当前用户右侧高亮星星
    private lazy var highlightIcon: UIImageView = {
        let v = UIImageView(image: UIImage(systemName: "star.fill"))
        v.tintColor = UIColor.fy.mainColor
        v.contentMode = .scaleAspectFit
        v.isHidden = true
        return v
    }()

    override func setupConstraint() {
        contentView.backgroundColor = UIColor.fy.white
        contentView.addSubview(rankLabel)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(highlightIcon)
        contentView.addSubview(scoreLabel)

        rankLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(28)
        }
        avatarImageView.snp.makeConstraints { make in
            make.leading.equalTo(rankLabel.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(highlightIcon.snp.leading).offset(-8)
        }
        highlightIcon.snp.makeConstraints { make in
            make.trailing.equalTo(scoreLabel.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(14)
        }
        scoreLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.equalTo(70)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        rankLabel.text = nil
        nameLabel.text = nil
        scoreLabel.text = nil
        avatarImageView.image = nil
        contentView.backgroundColor = UIColor.fy.white
        nameLabel.textColor = UIColor.fy.title
        nameLabel.font = UIFont.fy.system_15
        highlightIcon.isHidden = true
    }
}
