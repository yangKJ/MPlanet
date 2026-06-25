//
//  DiscoverSectionHeaderView.swift
//  WMDiscover
//
//  Created by UI Designer on 2024/5/24.
//  通用 section 标题视图：白底 + 绿色竖条 + 粗体标题 + 右侧「更多 >」
//

import UIKit
import RxSwift
import RxCocoa
import FeatBox
import SnapKit

/// 通用 section header viewModel
class DiscoverSectionHeaderViewModel: BaseTableViewSectionable {

    var title: String?
    var moreTitle: String?

    var cells: [BaseTableViewCellViewModelable]

    init(cells: [BaseTableViewCellViewModelable], title: String? = nil, moreTitle: String? = "更多") {
        self.cells = cells
        self.title = title
        self.moreTitle = moreTitle
        self.sectionFooterBackgroundColor = .clear
        // section 头背景给白色，让标题与卡片之间的层次清晰
        self.sectionHeaderBackgroundColor = UIColor.fy.white
    }
}

/// 通用 section header 视图
class DiscoverSectionHeaderView: BaseTableViewHeaderFooterView {

    let moreTap = PublishRelay<Void>()

    /// 左侧主题绿竖条
    private let line: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.fy.mainColor
        v.layer.cornerRadius = 2
        return v
    }()

    private let titleLabel: BaseLabel = {
        let l = BaseLabel()
        l.textColor = UIColor.fy.title
        l.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return l
    }()

    /// 右侧「更多」按钮：主色绿文字 + 右箭头
    private let moreButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("更多", for: .normal)
        b.setTitleColor(UIColor.fy.mainColor, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        b.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        b.tintColor = UIColor.fy.mainColor
        b.semanticContentAttribute = .forceRightToLeft
        b.imageEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: -3)
        return b
    }()

    /// 底部 1pt 浅灰分隔线
    private let bottomLine: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.fy.line
        return v
    }()

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }

    open override func refreshViews() {
        super.refreshViews()
        guard let vm = sectionViewModel as? DiscoverSectionHeaderViewModel else { return }
        titleLabel.text = vm.title
        if let more = vm.moreTitle, !more.isEmpty {
            moreButton.setTitle("\(more) ", for: .normal)
            moreButton.isHidden = false
        } else {
            moreButton.isHidden = true
        }
    }

    private func setupViews() {
        // 自定义刷新白色头
        self.contentView.backgroundColor = UIColor.fy.white
        self.backgroundView?.backgroundColor = UIColor.fy.white

        self.contentView.addSubview(line)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(moreButton)
        self.contentView.addSubview(bottomLine)

        line.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(4)
            make.height.equalTo(18)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(line.snp.right).offset(8)
            make.centerY.equalToSuperview()
            make.right.lessThanOrEqualTo(moreButton.snp.left).offset(-8)
        }
        moreButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.height.equalTo(28)
        }
        bottomLine.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(CGFloat.fy.px1)
        }

        moreButton.rx.tap
            .bind(to: moreTap)
            .disposed(by: rx.disposeBag)
    }
}
