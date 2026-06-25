//
//  LearnCourseCell.swift
//  WMLearn
//
//  Created by Condy on 2024/6/24.
//  美化说明：白卡课程 cell + 圆角缩略图 + 评分星 + 绿色价格
//

import UIKit
import FeatBox
import SnapKit

/// 课程列表 Cell ViewModel
class LearnCourseCellViewModel: BaseTableViewCellViewModelable {
    var cellType: FeatBox.BaseTableViewCell.Type {
        LearnCourseCell.self
    }
}

/// 课程列表 Cell（左图 + 右标题/讲师/价格）
class LearnCourseCell: BaseTableViewCell, HasDisposeBag {

    override var viewModel: BaseTableViewCellViewModelable? {
        didSet {
            guard let vm = viewModel as? LearnCourseCellViewModel,
                  let course = vm.datasource as? LearnCourse else {
                return
            }
            titleLabel.text = course.title
            teacherLabel.text = course.teacher ?? "-"
            priceLabel.text = String(format: "¥%.0f", course.price ?? 0)
            coverImageView.fy.setImage(with: course.coverImage)
            studentLabel.text = "\(course.studentCount ?? 0) 人在学"
            updateRating(course.rating ?? 0)
        }
    }

    /// 评分星容器（5 颗）
    private let starContainer: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.fy.clear
        return v
    }()

    private var starViews: [UIImageView] = []

    private lazy var coverImageView: UIImageView = {
        let view = BaseImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.backgroundColor = UIColor.fy.gray_F3F3F3
        return view
    }()

    /// 封面左上角"精品"角标
    private lazy var premiumBadge: BaseLabel = {
        let label = BaseLabel()
        label.text = "精品"
        label.textColor = UIColor.fy.white
        label.font = UIFont.systemFont(ofSize: 9, weight: .bold)
        label.textAlignment = .center
        label.backgroundColor = UIColor.fy.lightOrange
        label.layer.cornerRadius = 3
        label.layer.masksToBounds = true
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = BaseLabel()
        label.textColor = UIColor.fy.title
        label.font = UIFont.fy.bold(15)
        label.numberOfLines = 2
        return label
    }()

    private lazy var teacherLabel: UILabel = {
        let label = BaseLabel()
        label.textColor = UIColor.fy.detailTitle
        label.font = UIFont.fy.system_12
        return label
    }()

    private lazy var studentLabel: UILabel = {
        let label = BaseLabel()
        label.textColor = UIColor.fy.gray_999999
        label.font = UIFont.fy.system_10
        return label
    }()

    private lazy var ratingLabel: UILabel = {
        let label = BaseLabel()
        label.textColor = UIColor.fy.gray_999999
        label.font = UIFont.fy.system_10
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = BaseLabel()
        label.textColor = UIColor.fy.mainColor
        label.font = UIFont.fy.bold_16
        label.textAlignment = .right
        return label
    }()

    override func setupConstraint() {
        // 卡片式背景：白卡 + 圆角 + 阴影
        contentView.backgroundColor = UIColor.fy.white

        contentView.addSubview(coverImageView)
        contentView.addSubview(premiumBadge)
        contentView.addSubview(titleLabel)
        contentView.addSubview(teacherLabel)
        contentView.addSubview(starContainer)
        contentView.addSubview(studentLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(priceLabel)

        // 5 颗星
        for _ in 0..<5 {
            let star = UIImageView(image: UIImage(systemName: "star.fill"))
            star.tintColor = UIColor.systemYellow
            star.contentMode = .scaleAspectFit
            starContainer.addSubview(star)
            starViews.append(star)
        }
        var lastStar: UIImageView?
        for star in starViews {
            star.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.width.height.equalTo(10)
                if let last = lastStar {
                    make.leading.equalTo(last.snp.trailing).offset(1)
                } else {
                    make.leading.equalToSuperview()
                }
            }
            lastStar = star
        }

        // 行高 80pt（coverHeight = 80 - 24 = 56... 选 86pt 高）
        coverImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(72)
        }
        premiumBadge.snp.makeConstraints { make in
            make.top.leading.equalTo(coverImageView)
            make.width.equalTo(24)
            make.height.equalTo(14)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(coverImageView).offset(2)
            make.leading.equalTo(coverImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        teacherLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(titleLabel)
        }
        starContainer.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(teacherLabel.snp.bottom).offset(6)
            make.height.equalTo(10)
        }
        studentLabel.snp.makeConstraints { make in
            make.leading.equalTo(starContainer.snp.trailing).offset(6)
            make.centerY.equalTo(starContainer)
        }
        ratingLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalTo(starContainer)
        }
        priceLabel.snp.makeConstraints { make in
            make.bottom.equalTo(coverImageView)
            make.trailing.equalToSuperview().offset(-12)
            make.height.equalTo(22)
        }
    }

    /// 评分 0~5，半星精度
    private func updateRating(_ rating: Double) {
        let safe = max(0, min(5, rating))
        ratingLabel.text = String(format: "%.1f", safe)
        for (idx, star) in starViews.enumerated() {
            if Double(idx) + 1 <= safe {
                star.image = UIImage(systemName: "star.fill")
                star.tintColor = UIColor.systemYellow
            } else if Double(idx) + 0.5 <= safe {
                star.image = UIImage(systemName: "star.leadinghalf.filled")
                star.tintColor = UIColor.systemYellow
            } else {
                star.image = UIImage(systemName: "star")
                star.tintColor = UIColor.fy.gray_CCCCCC
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = nil
        titleLabel.text = nil
        teacherLabel.text = nil
        studentLabel.text = nil
        ratingLabel.text = nil
        priceLabel.text = nil
    }
}

/// 课程详情头部 Cell ViewModel
class LearnCourseHeaderCellViewModel: BaseTableViewCellViewModelable {
    var cellType: FeatBox.BaseTableViewCell.Type {
        LearnCourseHeaderCell.self
    }
}

/// 课程详情头部 Cell（视频封面 + 标题 + 介绍）
class LearnCourseHeaderCell: BaseTableViewCell, HasDisposeBag {

    override var viewModel: BaseTableViewCellViewModelable? {
        didSet {
            guard let vm = viewModel as? LearnCourseHeaderCellViewModel,
                  let course = vm.datasource as? LearnCourse else {
                return
            }
            coverImageView.fy.setImage(with: course.coverImage)
            titleLabel.text = course.title
            priceLabel.text = String(format: "¥%.0f", course.price ?? 0)
            teacherLabel.text = "讲师：\(course.teacher ?? "-") · 时长 \(course.duration ?? "-")"
            introLabel.text = course.intro
            updateRating(course.rating ?? 0)
            studentLabel.text = "\(course.studentCount ?? 0) 人在学"
        }
    }

    private lazy var coverImageView: UIImageView = {
        let view = BaseImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.backgroundColor = UIColor.fy.gray_F3F3F3
        return view
    }()

    /// 中央 ▶ 播放按钮（半透明圆形）
    private lazy var playButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(UIImage(systemName: "play.fill"), for: .normal)
        b.tintColor = UIColor.fy.white
        b.backgroundColor = UIColor.black.withAlphaComponent(0.45)
        b.layer.cornerRadius = 30
        b.layer.masksToBounds = true
        b.isUserInteractionEnabled = false
        return b
    }()

    private lazy var titleLabel: UILabel = {
        let label = BaseLabel()
        label.textColor = UIColor.fy.title
        label.font = UIFont.fy.bold_20
        label.numberOfLines = 2
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = BaseLabel()
        label.textColor = UIColor.fy.mainColor
        label.font = UIFont.fy.bold(22)
        label.textAlignment = .right
        return label
    }()

    private lazy var teacherLabel: UILabel = {
        let label = BaseLabel()
        label.textColor = UIColor.fy.detailTitle
        label.font = UIFont.fy.system_13
        return label
    }()

    private lazy var studentLabel: UILabel = {
        let label = BaseLabel()
        label.textColor = UIColor.fy.gray_999999
        label.font = UIFont.fy.system_12
        return label
    }()

    private lazy var ratingLabel: UILabel = {
        let label = BaseLabel()
        label.textColor = UIColor.fy.gray_999999
        label.font = UIFont.fy.system_12
        return label
    }()

    /// 评分星容器
    private let starContainer: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.fy.clear
        return v
    }()
    private var starViews: [UIImageView] = []

    private lazy var introLabel: UILabel = {
        let label = BaseLabel()
        label.textColor = UIColor.fy.black_666666
        label.font = UIFont.fy.system_14
        label.numberOfLines = 0
        return label
    }()

    /// 「课程简介」分组小标题
    private lazy var introTitle: UILabel = {
        let label = BaseLabel()
        label.text = "课程简介"
        label.textColor = UIColor.fy.title
        label.font = UIFont.fy.bold_16
        return label
    }()

    /// 简介标题左侧绿色竖线
    private lazy var introLine: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.fy.mainColor
        v.layer.cornerRadius = 1.5
        return v
    }()

    override func setupConstraint() {
        contentView.backgroundColor = UIColor.fy.white
        contentView.addSubview(coverImageView)
        contentView.addSubview(playButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(teacherLabel)
        contentView.addSubview(starContainer)
        contentView.addSubview(studentLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(introLine)
        contentView.addSubview(introTitle)
        contentView.addSubview(introLabel)

        // 评分星
        for _ in 0..<5 {
            let star = UIImageView(image: UIImage(systemName: "star.fill"))
            star.tintColor = UIColor.systemYellow
            star.contentMode = .scaleAspectFit
            starContainer.addSubview(star)
            starViews.append(star)
        }
        var lastStar: UIImageView?
        for star in starViews {
            star.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.width.height.equalTo(12)
                if let last = lastStar {
                    make.leading.equalTo(last.snp.trailing).offset(1)
                } else {
                    make.leading.equalToSuperview()
                }
            }
            lastStar = star
        }

        coverImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(coverImageView.snp.width).multipliedBy(9.0 / 16.0)
        }
        playButton.snp.makeConstraints { make in
            make.center.equalTo(coverImageView)
            make.width.height.equalTo(60)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom).offset(16)
            make.leading.equalTo(coverImageView)
            make.trailing.equalTo(priceLabel.snp.leading).offset(-8)
        }
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalTo(coverImageView)
            make.width.equalTo(90)
        }
        teacherLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(coverImageView)
            make.trailing.equalTo(coverImageView)
        }
        starContainer.snp.makeConstraints { make in
            make.top.equalTo(teacherLabel.snp.bottom).offset(8)
            make.leading.equalTo(coverImageView)
            make.height.equalTo(12)
        }
        studentLabel.snp.makeConstraints { make in
            make.leading.equalTo(starContainer.snp.trailing).offset(8)
            make.centerY.equalTo(starContainer)
        }
        ratingLabel.snp.makeConstraints { make in
            make.trailing.equalTo(coverImageView)
            make.centerY.equalTo(starContainer)
        }
        introLine.snp.makeConstraints { make in
            make.top.equalTo(starContainer.snp.bottom).offset(16)
            make.leading.equalTo(coverImageView)
            make.width.equalTo(3)
            make.height.equalTo(16)
        }
        introTitle.snp.makeConstraints { make in
            make.centerY.equalTo(introLine)
            make.leading.equalTo(introLine.snp.trailing).offset(8)
        }
        introLabel.snp.makeConstraints { make in
            make.top.equalTo(introLine.snp.bottom).offset(10)
            make.leading.equalTo(coverImageView)
            make.trailing.equalTo(coverImageView)
            make.bottom.equalToSuperview().offset(-16)
        }
    }

    private func updateRating(_ rating: Double) {
        let safe = max(0, min(5, rating))
        ratingLabel.text = String(format: "%.1f 分", safe)
        for (idx, star) in starViews.enumerated() {
            if Double(idx) + 1 <= safe {
                star.image = UIImage(systemName: "star.fill")
                star.tintColor = UIColor.systemYellow
            } else if Double(idx) + 0.5 <= safe {
                star.image = UIImage(systemName: "star.leadinghalf.filled")
                star.tintColor = UIColor.systemYellow
            } else {
                star.image = UIImage(systemName: "star")
                star.tintColor = UIColor.fy.gray_CCCCCC
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = nil
        titleLabel.text = nil
        priceLabel.text = nil
        teacherLabel.text = nil
        introLabel.text = nil
        ratingLabel.text = nil
        studentLabel.text = nil
    }
}

/// 章节 Cell ViewModel
class LearnChapterCellViewModel: BaseTableViewCellViewModelable {
    var cellType: FeatBox.BaseTableViewCell.Type {
        LearnChapterCell.self
    }
}

/// 章节 Cell（章节目录中的单行）
class LearnChapterCell: BaseTableViewCell, HasDisposeBag {

    override var viewModel: BaseTableViewCellViewModelable? {
        didSet {
            guard let vm = viewModel as? LearnChapterCellViewModel,
                  let chapter = vm.datasource as? LearnCourseChapter else {
                return
            }
            indexLabel.text = String(format: "%02d", vm_index)
            titleLabel.text = chapter.title
            durationLabel.text = chapter.duration
        }
    }

    /// 通过 datasource 反推 index（章节列表 cell 按顺序展示序号 1, 2, 3...）
    private var vm_index: Int = 1

    /// 序号左侧绿色 chip
    private lazy var indexLabel: UILabel = {
        let label = BaseLabel()
        label.textColor = UIColor.fy.white
        label.font = UIFont.fy.bold(11)
        label.textAlignment = .center
        label.backgroundColor = UIColor.fy.mainColor
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = BaseLabel()
        label.textColor = UIColor.fy.title
        label.font = UIFont.fy.system_14
        label.numberOfLines = 1
        return label
    }()

    private lazy var durationLabel: UILabel = {
        let label = BaseLabel()
        label.textColor = UIColor.fy.detailTitle
        label.font = UIFont.fy.system_12
        label.textAlignment = .right
        return label
    }()

    /// 右侧 ▶ SF Symbol（小）
    private lazy var playIcon: UIImageView = {
        let v = UIImageView(image: UIImage(systemName: "play.circle"))
        v.tintColor = UIColor.fy.mainColor
        v.contentMode = .scaleAspectFit
        return v
    }()

    override func setupConstraint() {
        contentView.backgroundColor = UIColor.fy.white
        contentView.addSubview(indexLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playIcon)
        contentView.addSubview(durationLabel)

        indexLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(28)
            make.height.equalTo(18)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(indexLabel.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(playIcon.snp.leading).offset(-8)
        }
        playIcon.snp.makeConstraints { make in
            make.trailing.equalTo(durationLabel.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(18)
        }
        durationLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        indexLabel.text = nil
        titleLabel.text = nil
        durationLabel.text = nil
    }
}
