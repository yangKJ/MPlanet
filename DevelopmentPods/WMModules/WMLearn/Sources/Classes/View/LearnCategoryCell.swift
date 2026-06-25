//
//  LearnCategoryCell.swift
//  WMLearn
//
//  Created by Condy on 2024/6/24.
//  美化说明：6 分类宫格改为白卡 + 圆角 icon + 名称 + 进度条 + 阴影
//

import UIKit
import FeatBox
import Mediator
import SnapKit

/// 6 大分类宫格 Cell ViewModel
class LearnCategoryCellViewModel: BaseTableViewCellViewModelable {
    var cellType: FeatBox.BaseTableViewCell.Type {
        LearnCategoryCell.self
    }
}

/// 6 大分类宫格 Cell
/// 内部使用 2 行 x 3 列 UICollectionView 展示分类入口
class LearnCategoryCell: BaseTableViewCell, HasDisposeBag {

    override var viewModel: BaseTableViewCellViewModelable? {
        didSet {
            guard let vm = viewModel as? LearnCategoryCellViewModel,
                  let list = vm.datasource as? [LearnCategory] else {
                return
            }
            self.dataSourceRelay.accept(list)
        }
    }

    private let dataSourceRelay = BehaviorRelay<[LearnCategory]>(value: [])

    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.fy.clear
        view.isScrollEnabled = false
        view.showsVerticalScrollIndicator = false
        view.register(LearnCategoryItemCell.self,
                      forCellWithReuseIdentifier: "LearnCategoryItemCell")
        return view
    }()

    override func setupConstraint() {
        // 外层 cell 透明，背景由外部页面（白卡风格）覆盖
        contentView.backgroundColor = UIColor.fy.clear
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // 绑定数据源
        dataSourceRelay
            .observe(on: MainScheduler.instance)
            .bind(to: collectionView.rx.items) { (collectionView, row, element) in
                let indexPath = IndexPath(item: row, section: 0)
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "LearnCategoryItemCell",
                    for: indexPath) as! LearnCategoryItemCell
                cell.item = element
                return cell
            }.disposed(by: rx.disposeBag)

        // 点击分类 → 通过 Mediator 跳转到分类课程列表
        collectionView.rx.itemSelected
            .withLatestFrom(dataSourceRelay) { ($0, $1) }
            .subscribe(onNext: { indexPath, list in
                guard indexPath.item < list.count else { return }
                let category = list[indexPath.item]
                guard let categoryId = category.id else { return }
                if let vc = Mediator.performTarget(
                    "LearnTarget",
                    action: "Action_categoryViewController:",
                    module: "WMLearn",
                    params: ["categoryId": categoryId]
                ) as? UIViewController {
                    UIViewController.fy.currentViewController()?
                        .navigationController?
                        .pushViewController(vc, animated: true)
                }
            }).disposed(by: rx.disposeBag)

        // 动态计算 itemSize：3 列等宽
        Observable.just(())
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.updateItemSize()
            }).disposed(by: rx.disposeBag)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateItemSize()
    }

    private func updateItemSize() {
        let totalWidth = contentView.bounds.width
        let columns: CGFloat = 3
        let spacing: CGFloat = 8
        let insets: CGFloat = 16
        let itemWidth = floor((totalWidth - spacing * (columns - 1) - insets * 2) / columns)
        // 高度与 itemWidth 相近保持方形视觉
        let itemHeight = itemWidth + 16
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.invalidateLayout()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        // 清空状态：重置 disposeBag 由 BaseTableViewCell.prepareForReuse 已处理
        dataSourceRelay.accept([])
    }
}

/// 6 宫格中的单个 item（圆角 icon 容器 + 名称 + 进度条）
class LearnCategoryItemCell: BaseCollectionViewCell {

    var item: LearnCategory? {
        didSet {
            guard let item = item else { return }
            titleLabel.text = item.title

            // 课程数 / 学员数
            if let count = item.courseCount {
                subtitleLabel.text = "\(count) 门课 · \(item.studentCount ?? 0) 学员"
            } else {
                subtitleLabel.text = nil
            }

            // SF Symbol icon（如系统不支持则用 music.note）
            if let name = item.icon, UIImage(systemName: name) != nil {
                iconView.image = UIImage(systemName: name)
            } else {
                iconView.image = UIImage(systemName: "music.note")
            }
            iconView.tintColor = UIColor.fy.mainColor

            // 进度条：根据 id 模拟一个稳定的进度（无真实字段）
            let total = max(1, item.courseCount ?? 1)
            let learned = max(0, min(total, (item.id ?? 0) % total))
            let ratio = CGFloat(learned) / CGFloat(total)
            progressView.setProgress(Float(ratio), animated: false)
            progressLabel.text = "已学 \(learned)/\(total)"
        }
    }

    /// icon 浅绿色背景圆角矩形
    private lazy var iconBackground: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.fy.mainColor.withAlphaComponent(0.12)
        v.layer.cornerRadius = 16
        v.layer.masksToBounds = true
        return v
    }()

    private lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = UIColor.fy.mainColor
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = BaseLabel()
        label.textColor = UIColor.fy.title
        label.font = UIFont.fy.system_14
        label.textAlignment = .center
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = BaseLabel()
        label.textColor = UIColor.fy.detailTitle
        label.font = UIFont.fy.system_10
        label.textAlignment = .center
        return label
    }()

    /// 底部进度条
    private lazy var progressView: UIProgressView = {
        let v = UIProgressView(progressViewStyle: .bar)
        v.trackTintColor = UIColor.fy.gray_F3F3F3
        v.progressTintColor = UIColor.fy.mainColor
        v.layer.cornerRadius = 2
        v.layer.masksToBounds = true
        return v
    }()

    private lazy var progressLabel: UILabel = {
        let label = BaseLabel()
        label.textColor = UIColor.fy.gray_999999
        label.font = UIFont.fy.system_10
        label.textAlignment = .right
        return label
    }()

    override func setupConstraint() {
        contentView.backgroundColor = UIColor.fy.clear

        contentView.addSubview(iconBackground)
        iconBackground.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(progressView)
        contentView.addSubview(progressLabel)

        iconBackground.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(56)
        }
        iconView.snp.makeConstraints { make in
            make.center.equalTo(iconBackground)
            make.width.height.equalTo(28)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconBackground.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview()
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview()
        }
        progressView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.height.equalTo(4)
        }
        progressLabel.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview().inset(4)
        }
    }

    override func clearReuseContent() {
        super.clearReuseContent()
        iconView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
        progressLabel.text = nil
        progressView.setProgress(0, animated: false)
    }
}
