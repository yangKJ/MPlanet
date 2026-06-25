//
//  LearnVideoCardCell.swift
//  WMLearn
//
//  Created by Condy on 2024/6/24.
//  美化说明：白卡 + 顶部标题行 + 横向缩略图卡 + ▶ 中央播放按钮 + 时长 chip
//

import UIKit
import FeatBox
import Mediator
import SnapKit

/// 视频赔价榜 Cell ViewModel
class LearnVideoCardCellViewModel: BaseTableViewCellViewModelable {
    var cellType: FeatBox.BaseTableViewCell.Type {
        LearnVideoCardCell.self
    }
}

/// 视频赔价榜 Cell（横向滚动视频列表入口）
class LearnVideoCardCell: BaseTableViewCell, HasDisposeBag {

    override var viewModel: BaseTableViewCellViewModelable? {
        didSet {
            guard let vm = viewModel as? LearnVideoCardCellViewModel,
                  let list = vm.datasource as? [LearnVideoCard] else {
                return
            }
            self.dataSourceRelay.accept(list)
        }
    }

    private let dataSourceRelay = BehaviorRelay<[LearnVideoCard]>(value: [])

    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.fy.clear
        view.showsHorizontalScrollIndicator = false
        view.register(LearnVideoCardItemCell.self,
                      forCellWithReuseIdentifier: "LearnVideoCardItemCell")
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = BaseLabel()
        label.text = "视频赔价榜"
        label.textColor = UIColor.fy.title
        label.font = UIFont.fy.bold_16
        return label
    }()

    /// 标题左侧绿色竖线
    private lazy var titleLine: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.fy.mainColor
        v.layer.cornerRadius = 1.5
        return v
    }()

    private lazy var arrowButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("查看全部", for: .normal)
        b.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        b.tintColor = UIColor.fy.gray_999999
        b.setTitleColor(UIColor.fy.gray_999999, for: .normal)
        b.titleLabel?.font = UIFont.fy.system_12
        b.semanticContentAttribute = .forceRightToLeft
        b.imageEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: -2)
        return b
    }()

    override func setupConstraint() {
        contentView.backgroundColor = UIColor.fy.white

        contentView.addSubview(titleLine)
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowButton)
        contentView.addSubview(collectionView)

        titleLine.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(3)
            make.height.equalTo(16)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLine)
            make.leading.equalTo(titleLine.snp.trailing).offset(8)
        }
        arrowButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLine)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(20)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(180)
            make.bottom.equalToSuperview().offset(-12)
        }

        // item size 固定
        layout.itemSize = CGSize(width: 160, height: 170)

        dataSourceRelay
            .observe(on: MainScheduler.instance)
            .bind(to: collectionView.rx.items) { (collectionView, row, element) in
                let indexPath = IndexPath(item: row, section: 0)
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "LearnVideoCardItemCell",
                    for: indexPath) as! LearnVideoCardItemCell
                cell.item = element
                return cell
            }.disposed(by: rx.disposeBag)

        // 点击"查看全部"或整行 → 跳到完整视频赔价榜
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        contentView.addGestureRecognizer(tap)
        arrowButton.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }

    @objc private func handleTap() {
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
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        dataSourceRelay.accept([])
    }
}

/// 视频赔价榜中的单个视频条目（卡片：缩略图 + ▶ + 时长 chip + 标题 + 播放数）
class LearnVideoCardItemCell: BaseCollectionViewCell {

    var item: LearnVideoCard? {
        didSet {
            guard let item = item else { return }
            coverImageView.fy.setImage(with: item.coverImage)
            titleLabel.text = item.title
            teacherLabel.text = item.teacher
            durationLabel.text = item.duration ?? "00:00"
            let count = item.playCount ?? 0
            if count > 10000 {
                playLabel.text = String(format: "%.1f万播放", Double(count) / 10000.0)
            } else {
                playLabel.text = "\(count)播放"
            }
        }
    }

    private lazy var coverContainer: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 8
        v.layer.masksToBounds = true
        v.backgroundColor = UIColor.fy.gray_F3F3F3
        return v
    }()

    private lazy var coverImageView: UIImageView = {
        let view = BaseImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()

    /// 中央 ▶ 圆形播放按钮
    private lazy var playButton: UIButton = {
        let b = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        b.setImage(UIImage(systemName: "play.fill", withConfiguration: config), for: .normal)
        b.tintColor = UIColor.fy.white
        b.backgroundColor = UIColor.black.withAlphaComponent(0.45)
        b.layer.cornerRadius = 22
        b.layer.masksToBounds = true
        b.isUserInteractionEnabled = false
        return b
    }()

    /// 时长 chip（右下角）
    private lazy var durationLabel: UILabel = {
        let label = BaseLabel()
        label.textColor = UIColor.fy.white
        label.font = UIFont.fy.system_10
        label.textAlignment = .center
        label.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        label.layer.cornerRadius = 3
        label.layer.masksToBounds = true
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = BaseLabel()
        label.textColor = UIColor.fy.title
        label.font = UIFont.fy.bold(13)
        label.numberOfLines = 2
        return label
    }()

    private lazy var teacherLabel: UILabel = {
        let label = BaseLabel()
        label.textColor = UIColor.fy.gray_999999
        label.font = UIFont.fy.system(11)
        label.numberOfLines = 1
        return label
    }()

    private lazy var playLabel: UILabel = {
        let label = BaseLabel()
        label.textColor = UIColor.fy.gray_999999
        label.font = UIFont.fy.system_10
        label.numberOfLines = 1
        return label
    }()

    /// ▶ icon
    private lazy var playIcon: UIImageView = {
        let v = UIImageView(image: UIImage(systemName: "play.fill"))
        v.tintColor = UIColor.fy.mainColor
        v.contentMode = .scaleAspectFit
        return v
    }()

    override func setupConstraint() {
        contentView.backgroundColor = UIColor.fy.clear
        contentView.addSubview(coverContainer)
        coverContainer.addSubview(coverImageView)
        coverContainer.addSubview(playButton)
        coverContainer.addSubview(durationLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(teacherLabel)
        contentView.addSubview(playIcon)
        contentView.addSubview(playLabel)

        coverContainer.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(90)
        }
        coverImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        playButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(44)
        }
        durationLabel.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().inset(6)
            make.height.equalTo(16)
            make.width.greaterThanOrEqualTo(36)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(coverContainer.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
        teacherLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
        }
        playIcon.snp.makeConstraints { make in
            make.top.equalTo(teacherLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview()
            make.width.height.equalTo(10)
        }
        playLabel.snp.makeConstraints { make in
            make.leading.equalTo(playIcon.snp.trailing).offset(4)
            make.centerY.equalTo(playIcon)
            make.trailing.lessThanOrEqualToSuperview()
        }
    }

    override func clearReuseContent() {
        super.clearReuseContent()
        coverImageView.image = nil
        titleLabel.text = nil
        teacherLabel.text = nil
        durationLabel.text = nil
        playLabel.text = nil
    }
}
