//
//  BaseSwitcherCell.swift
//  FeatBox
//
//  Created by Condy on 2024/5/20.
//

import Foundation
import ProductLib
import RxCocoa
import SnapKit

public final class BaseSwitcherCellViewModel: BaseFormCellViewModel {
    
    public let isOn = BehaviorRelay<Bool>(value: false)
    public let onTintColor = PublishRelay<UIColor?>()
    
    fileprivate var switchChangedBlock: (() -> Void)?
    public func setSwitchChanged(block: @escaping () -> Void) {
        switchChangedBlock = block
    }
}

/// 左右排版切换器Cell
open class BaseSwitcherCell: BaseFormCell {
    
    open override func hasArrowViewUpdateSubViewConstraint(_ has: Bool) {
        self.switcher.snp.updateConstraints { (make) in
            make.right.equalTo(has ? -30 : -15)
        }
    }
    
    open override func setupConstraint() {
        super.setupConstraint()
        self.contentView.addSubview(self.switcher)
        self.switcher.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
            make.top.greaterThanOrEqualTo(13)
        }
    }
    
    open override func setupBindings() {
        super.setupBindings()
        guard let viewModel = viewModel as? BaseSwitcherCellViewModel else {
            return
        }
        viewModel.isOn.distinctUntilChanged()
            .bind(to: self.switcher.rx.isOn)
            .disposed(by: disposeBag)
        viewModel.onTintColor.distinctUntilChanged()
            .bind(to: self.switcher.rx.onTintColor)
            .disposed(by: disposeBag)
    }
    
    // MARK: - private methods
    
    private lazy var switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        switcher.onTintColor = UIColor.fy.mainColor
        return switcher
    }()
    
    @objc private func switchChanged() {
        guard let viewModel = viewModel as? BaseSwitcherCellViewModel else {
            return
        }
        viewModel.switchChangedBlock?()
    }
}
