//
//  TopicsSegmentedControl.swift
//  WMTopics
//
//  Created by Condy on 2024/5/24.
//  主题 Tab 顶部 3 tab 切换控件（最新/热门/我的关注）
//

import UIKit
import FeatBox
import SnapKit
import RxSwift
import RxCocoa

/// 主题 Tab 顶部分段控件
/// 包装 UISegmentedControl，对外暴露当前选中的 type key
class TopicsSegmentedControl: UIView, HasDisposeBag {

    /// 选中事件：参数为 type key：latest / hot / following
    let typeSelected = PublishRelay<String>()

    /// 当前选中的 type
    private(set) var currentType: String = "latest"

    /// 顶部安全区 inset（由外层 VC 在 viewDidLayoutSubviews 中传入）
    private var safeAreaTopInset: CGFloat = 0

    /// 暴露给外层 VC 调用的方法：更新顶部安全区 inset
    func updateSafeAreaInset(_ top: CGFloat) {
        guard self.safeAreaTopInset != top else { return }
        self.safeAreaTopInset = top
        segmented.snp.updateConstraints { make in
            make.top.equalToSuperview().offset(top + 6)
        }
    }

    private let items: [String] = ["最新", "热门", "我的关注"]
    private let typeKeys: [String] = ["latest", "hot", "following"]

    private lazy var segmented: UISegmentedControl = {
        let items = self.items
        let sc = UISegmentedControl(items: items)
        sc.selectedSegmentIndex = 0
        // 适配绿色主题
        sc.selectedSegmentTintColor = UIColor.fy.white
        sc.setTitleTextAttributes([
            .foregroundColor: UIColor.fy.white,
            .font: UIFont.fy.system_14
        ], for: .normal)
        sc.setTitleTextAttributes([
            .foregroundColor: UIColor.fy.mainColor,
            .font: UIFont.fy.bold(14)
        ], for: .selected)
        sc.backgroundColor = UIColor.fy.clear
        return sc
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
        self.setupBindings()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupViews()
        self.setupBindings()
    }

    private func setupViews() {
        self.backgroundColor = UIColor.fy.mainColor
        self.addSubview(segmented)
        segmented.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().offset(-6)
        }
    }

    private func setupBindings() {
        segmented.rx.selectedSegmentIndex
            .skip(1)
            .subscribe(onNext: { [weak self] index in
                guard let self = self, index >= 0, index < self.typeKeys.count else { return }
                self.currentType = self.typeKeys[index]
                self.typeSelected.accept(self.currentType)
            }).disposed(by: rx.disposeBag)
    }
}
