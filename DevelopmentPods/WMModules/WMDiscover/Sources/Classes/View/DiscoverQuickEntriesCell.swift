//
//  DiscoverQuickEntriesCell.swift
//  WMDiscover
//
//  Created by UI Designer on 2024/5/24.
//  6 宫格学习区入口：白卡 + 浅灰背景圆角 + SF Symbol + 缩放高亮
//

import UIKit
import RxSwift
import RxCocoa
import FeatBox
import SnapKit

/// 6 宫格入口 cell viewModel
class DiscoverQuickEntriesCellViewModel: BaseTableViewCellViewModelable {

    var cellType: FeatBox.BaseTableViewCell.Type {
        DiscoverQuickEntriesCell.self
    }

    /// 固定高度：2 行 × (icon + text + spacing) ≈ 200
    var cellHeight: CGFloat?
}

/// 6 宫格学习入口 cell
class DiscoverQuickEntriesCell: BaseTableViewCell, HasDisposeBag {

    /// 点击入口的回调，参数为 (id, title)
    var tapEntryBlock: ((Int, String) -> Void)?

    /// 3 列 × 2 行布局
    private let columnCount = 3
    private var items: [DiscoverQuickEntryItem] = []

    /// 卡片容器（让整体呈现为一张白卡，圆角 + 阴影）
    private let cardContainer: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.fy.white
        // 美化：圆角 12 → 14，与 Post/Ranking cell 视觉语言一致
        v.layer.cornerRadius = 14
        v.layer.masksToBounds = false
        v.layer.shadowColor = UIColor.fy.black.cgColor
        v.layer.shadowOpacity = 0.06
        v.layer.shadowRadius = 8
        v.layer.shadowOffset = CGSize(width: 0, height: 2)
        return v
    }()

    private let stackView: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.alignment = .fill
        s.distribution = .fillEqually
        s.spacing = 12
        return s
    }()

    override var viewModel: BaseTableViewCellViewModelable? {
        didSet {
            // 每次赋值都重置（处理 cell 复用）
            self.items = DiscoverQuickEntryItem.defaults
            self.rebuildItems()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        // clearReuseContent 会清空 imageView，清空自定义回调防止旧的闭包泄漏
        self.tapEntryBlock = nil
    }

    override func setupConstraint() {
        // 外层为页面灰背景，cell 本身保持透明，卡片为白
        self.backgroundColor = UIColor.fy.clear
        self.contentView.backgroundColor = UIColor.fy.clear
        self.contentView.addSubview(cardContainer)
        cardContainer.addSubview(stackView)

        cardContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12))
        }
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12))
        }
        self.items = DiscoverQuickEntryItem.defaults
        self.rebuildItems()
    }

    // MARK: - Private

    private func rebuildItems() {
        // 清空旧 subview
        for v in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(v)
            v.removeFromSuperview()
        }

        // 按 3 列分组
        let rows = stride(from: 0, to: items.count, by: columnCount).map {
            Array(items[$0..<min($0 + columnCount, items.count)])
        }

        for row in rows {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.alignment = .fill
            rowStack.distribution = .fillEqually
            rowStack.spacing = 8
            for item in row {
                rowStack.addArrangedSubview(makeEntryView(item: item))
            }
            stackView.addArrangedSubview(rowStack)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // 美化：给 cardContainer 显式设 shadow path，跟圆角走，滚动省离屏
        let path = UIBezierPath(
            roundedRect: cardContainer.bounds,
            cornerRadius: 14
        ).cgPath
        cardContainer.layer.shadowPath = path
    }

    private func makeEntryView(item: DiscoverQuickEntryItem) -> UIView {
        let container = UIControl()
        // 美化：单格背景从 gray_F7F7F7 → white，配合外层卡片更"内陷"
        container.backgroundColor = UIColor.fy.white
        container.layer.cornerRadius = 12
        container.layer.masksToBounds = true
        // 美化：单格描边 0.5pt 主色 8% 透明,让内陷格子有边界
        container.layer.borderColor = UIColor.fy.mainColor.withAlphaComponent(0.08).cgColor
        container.layer.borderWidth = 0.5
        container.tag = item.id

        // 美化：iconBg 渐变层（主色绿 → 主色绿 0.7）
        let iconBg = UIView()
        iconBg.layer.cornerRadius = 20
        iconBg.layer.masksToBounds = true
        iconBg.isUserInteractionEnabled = false

        let iconGradient = CAGradientLayer()
        iconGradient.colors = [
            UIColor.fy.mainColor.cgColor,
            UIColor.fy.mainColor.withAlphaComponent(0.7).cgColor
        ]
        iconGradient.startPoint = CGPoint(x: 0, y: 0)
        iconGradient.endPoint = CGPoint(x: 1, y: 1)
        iconBg.layer.insertSublayer(iconGradient, at: 0)

        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        // 美化：icon 颜色从主色 → 白色（配深绿渐变底更跳）
        iconView.tintColor = UIColor.fy.white
        iconView.image = UIImage(systemName: item.iconName) ?? UIImage(systemName: "questionmark.circle")
        if iconView.image == nil {
            iconView.image = UIImage(systemName: "music.note")
        }
        iconView.isUserInteractionEnabled = false

        let titleLabel = BaseLabel()
        titleLabel.text = item.title
        titleLabel.textColor = UIColor.fy.title
        // 美化：标题 13 medium → 13 semibold 更有信息层级
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.isUserInteractionEnabled = false

        container.addSubview(iconBg)
        container.addSubview(iconView)
        container.addSubview(titleLabel)

        iconBg.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(40)
        }
        iconView.snp.makeConstraints { make in
            make.center.equalTo(iconBg)
            make.width.height.equalTo(40)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconBg.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(4)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }

        // 点击高亮：缩小 + 透明度反馈
        container.addTarget(self, action: #selector(entryDown(_:)),
                            for: [.touchDown, .touchDragInside])
        container.addTarget(self, action: #selector(entryUp(_:)),
                            for: [.touchUpInside, .touchUpOutside, .touchCancel, .touchDragExit])
        container.addTarget(self, action: #selector(entryTapped(_:)), for: .touchUpInside)

        // 美化：layout 完后给 iconBg 渐变层绑 frame
        DispatchQueue.main.async {
            iconGradient.frame = iconBg.bounds
        }
        return container
    }

    @objc private func entryDown(_ sender: UIControl) {
        // 美化：弹性 spring 动画，触感更真
        UIView.animate(withDuration: 0.18,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.6,
                       options: [.allowUserInteraction, .curveEaseInOut],
                       animations: {
            sender.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
            sender.alpha = 0.85
        })
    }

    @objc private func entryUp(_ sender: UIControl) {
        // 美化：弹性回弹
        UIView.animate(withDuration: 0.22,
                       delay: 0,
                       usingSpringWithDamping: 0.65,
                       initialSpringVelocity: 0.5,
                       options: [.allowUserInteraction, .curveEaseInOut],
                       animations: {
            sender.transform = .identity
            sender.alpha = 1.0
        })
    }

    @objc private func entryTapped(_ sender: UIControl) {
        guard let item = items.first(where: { $0.id == sender.tag }) else {
            return
        }
        // 暂时 stub：未来跳转 WMLearn，参数为分类 id
        print("[DiscoverQuickEntries] tap id=\(item.id) title=\(item.title)")
        self.tapEntryBlock?(item.id, item.title)
    }
}
