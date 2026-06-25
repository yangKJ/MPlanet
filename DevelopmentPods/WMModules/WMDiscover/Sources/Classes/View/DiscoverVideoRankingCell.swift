//
//  DiscoverVideoRankingCell.swift
//  WMDiscover
//
//  Created by UI Designer on 2024/5/24.
//  视频赔价榜入口：横向滚动的视频卡片 + 渐变蒙层 + 排名 badge
//

import UIKit
import RxSwift
import RxCocoa
import FeatBox
import SnapKit

/// 视频榜 cell viewModel
class DiscoverVideoRankingCellViewModel: BaseTableViewCellViewModelable {

    var cellType: FeatBox.BaseTableViewCell.Type {
        DiscoverVideoRankingCell.self
    }

    var cellHeight: CGFloat?
}

/// 视频赔价榜入口 cell
class DiscoverVideoRankingCell: BaseTableViewCell, HasDisposeBag {

    /// 横向滚动 collection view（每个 item 是视频卡片）
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        layout.itemSize = CGSize(width: 144, height: 200)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.fy.clear
        cv.showsHorizontalScrollIndicator = false
        cv.alwaysBounceHorizontal = true
        return cv
    }()

    private var items: [DiscoverVideoRanking] = []

    override var viewModel: BaseTableViewCellViewModelable? {
        didSet {
            // 处理 cell 复用
            if let list = viewModel?.datasource as? [DiscoverVideoRanking] {
                self.items = list.sorted(by: { ($0.sort ?? 0) < ($1.sort ?? 0) })
            } else {
                self.items = []
            }
            self.collectionView.reloadData()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        // 清空 imageView 内容
        self.items = []
        self.collectionView.reloadData()
    }

    override func setupConstraint() {
        // 透明背景，让外面 section 的灰底透出（如果 cell 直接处于 table 时则由 table 负责背景）
        self.backgroundColor = UIColor.fy.clear
        self.contentView.backgroundColor = UIColor.fy.clear
        self.contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 0, bottom: 8, right: 0))
            make.height.equalTo(200)
        }
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(DiscoverVideoRankingItemCell.self, forCellWithReuseIdentifier: DiscoverVideoRankingItemCell.fy.class_name)
    }
}

extension DiscoverVideoRankingCell: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscoverVideoRankingItemCell.fy.class_name,
                                                      for: indexPath) as! DiscoverVideoRankingItemCell
        if let item = items[safe: indexPath.item] {
            cell.update(with: item, rank: indexPath.item + 1)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = items[safe: indexPath.item] else { return }
        print("[DiscoverVideoRanking] tap id=\(item.id ?? 0) title=\(item.title ?? "")")
    }
}

/// 视频榜单项
class DiscoverVideoRankingItemCell: UICollectionViewCell {

    /// 缩略图容器（用于裁剪外圆角 + 内部叠加蒙层和文字）
    private let thumbContainer: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 14
        v.layer.masksToBounds = true
        v.backgroundColor = UIColor.fy.backgroundGray
        return v
    }()

    /// 美化：排名徽章渐变层（金/银/铜/绿）
    /// 用 CAGradientLayer 在 layoutSubviews 里动态绑到 rankBadge 上
    private var rankGradientLayer: CAGradientLayer?

    private let thumbView: BaseImageView = {
        let v = BaseImageView()
        v.contentMode = .scaleAspectFill
        return v
    }()

    /// 缩略图底部黑色渐变蒙层（让标题文字易读）
    private let gradientOverlay: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.55).cgColor
        ]
        layer.startPoint = CGPoint(x: 0, y: 0.45)
        layer.endPoint = CGPoint(x: 0, y: 1)
        return layer
    }()

    /// 排名 badge：1 金 / 2 银 / 3 铜 / 4+ 主题绿，渐变 + 圆角 6
    private let rankBadge: BaseLabel = {
        let l = BaseLabel()
        l.textColor = UIColor.fy.white
        l.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        l.textAlignment = .center
        l.layer.cornerRadius = 6
        l.layer.masksToBounds = true
        // 美化：字距 0.5 让数字更精致
        l.layer.shadowColor = UIColor.fy.black.cgColor
        l.layer.shadowOpacity = 0.18
        l.layer.shadowOffset = CGSize(width: 0, height: 1)
        l.layer.shadowRadius = 2
        return l
    }()

    /// 美化：播放图标底圆盘，半透明白，让播放按钮在缩略图上更跳
    private let playBadge: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.fy.black.withAlphaComponent(0.35)
        v.layer.cornerRadius = 12
        v.layer.masksToBounds = true
        return v
    }()

    /// 播放图标
    private let playIcon: UIImageView = {
        let v = UIImageView()
        v.tintColor = UIColor.fy.white.withAlphaComponent(0.9)
        v.image = UIImage(systemName: "play.fill")
        v.contentMode = .scaleAspectFit
        return v
    }()

    private let titleOnCover: BaseLabel = {
        let l = BaseLabel()
        l.textColor = UIColor.fy.white
        l.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        l.numberOfLines = 2
        return l
    }()

    private let playLabel: BaseLabel = {
        let l = BaseLabel()
        l.textColor = UIColor.fy.detailTitle
        l.font = UIFont.fy.system_12
        l.numberOfLines = 1
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // 渐变层 frame 需要跟随缩略图容器尺寸
        gradientOverlay.frame = thumbContainer.bounds
        // 美化：显式设 shadow path 跟 contentView 圆角走，滚动时省离屏渲染
        let path = UIBezierPath(
            roundedRect: contentView.bounds,
            cornerRadius: 14
        ).cgPath
        contentView.layer.shadowPath = path
        // 美化：排名徽章渐变层 frame 跟 rankBadge 走
        rankGradientLayer?.frame = rankBadge.bounds
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.thumbView.image = nil
        self.titleOnCover.text = nil
        self.playLabel.text = nil
        self.rankBadge.text = nil
    }

    private func setupViews() {
        self.contentView.addSubview(thumbContainer)
        thumbContainer.addSubview(thumbView)
        thumbContainer.layer.addSublayer(gradientOverlay)
        thumbContainer.addSubview(rankBadge)
        // 美化：playIcon 嵌进 playBadge 圆盘里
        thumbContainer.addSubview(playBadge)
        playBadge.addSubview(playIcon)
        thumbContainer.addSubview(titleOnCover)

        self.contentView.addSubview(playLabel)

        // 阴影：轻量卡片投影
        self.contentView.layer.shadowColor = UIColor.fy.black.cgColor
        self.contentView.layer.shadowOpacity = 0.08
        self.contentView.layer.shadowRadius = 6
        self.contentView.layer.shadowOffset = CGSize(width: 0, height: 3)
        // shadow path 在 layoutSubviews 里显式设

        thumbContainer.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(144)
        }
        thumbView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        rankBadge.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(8)
            make.width.equalTo(26)
            make.height.equalTo(20)
        }
        // 美化：playBadge 圆盘包住 playIcon，视觉更立体
        playBadge.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.width.height.equalTo(24)
        }
        playIcon.snp.makeConstraints { make in
            make.center.equalTo(playBadge)
            make.width.height.equalTo(12)
        }
        titleOnCover.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
        playLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbContainer.snp.bottom).offset(6)
            make.left.right.equalToSuperview().inset(2)
        }
    }

    func update(with item: DiscoverVideoRanking, rank: Int) {
        self.rankBadge.text = "\(rank)"
        // 美化：1 金 / 2 银 / 3 铜 / 4+ 主题绿 渐变
        applyRankGradient(rank: rank)
        self.titleOnCover.text = item.title
        let count = item.playCount ?? 0
        if count > 10000 {
            self.playLabel.text = String(format: "%.1f万播放", Double(count) / 10000.0)
        } else {
            self.playLabel.text = "\(count)播放"
        }
        self.thumbView.fy.setImage(with: item.imagePath)
    }

    /// 美化：根据排名给 rankBadge 装上不同的渐变层
    /// 金 #FFD86E → #FF9A3D, 银 #E0E5EA → #A6B0BD, 铜 #F5B17A → #C47A45, 4+ 主色绿
    private func applyRankGradient(rank: Int) {
        // 先清掉旧的渐变层
        rankGradientLayer?.removeFromSuperlayer()
        rankGradientLayer = nil

        let colors: [UIColor]
        let start: CGPoint
        let end: CGPoint
        switch rank {
        case 1:
            colors = [UIColor(hex: "#FFD86E"), UIColor(hex: "#FF9A3D")]
            start = CGPoint(x: 0, y: 0); end = CGPoint(x: 1, y: 1)
        case 2:
            colors = [UIColor(hex: "#E0E5EA"), UIColor(hex: "#A6B0BD")]
            start = CGPoint(x: 0, y: 0); end = CGPoint(x: 1, y: 1)
        case 3:
            colors = [UIColor(hex: "#F5B17A"), UIColor(hex: "#C47A45")]
            start = CGPoint(x: 0, y: 0); end = CGPoint(x: 1, y: 1)
        default:
            colors = [UIColor.fy.mainColor, UIColor.fy.mainColor.withAlphaComponent(0.78)]
            start = CGPoint(x: 0, y: 0); end = CGPoint(x: 1, y: 0)
        }
        let gradient = CAGradientLayer()
        gradient.colors = colors.map { $0.cgColor }
        gradient.startPoint = start
        gradient.endPoint = end
        gradient.frame = rankBadge.bounds
        rankBadge.layer.insertSublayer(gradient, at: 0)
        rankGradientLayer = gradient
    }
}
