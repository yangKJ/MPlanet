//
//  BannerDetailCell.swift
//  WMDiscover
//
//  Created by Condy on 2023/5/31.
//

import Foundation
import FeatBox

class BannerDetailCell: BaseTableViewCell {
    
    let detail = BehaviorRelay<BannerDetail?>(value: nil)
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.fy.mainColor
        view.layer.cornerRadius = 25
        view.isUserInteractionEnabled = true
        return view
    }()
    
    var heightConstraint: Constraint?
    
    override func setupConstraint() {
        contentView.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
            self.heightConstraint = make.height.equalTo(300).constraint
        }
    }
    
    override func setupBindings() {
        detail.subscribe(onNext: { [weak self] in
            self?.backView.backgroundColor = $0?.background
            //self?.backView.layoutIfNeeded()
            self?.heightConstraint?.update(offset: $0?.height ?? 300)
        }).disposed(by: rx.disposeBag)
    }
}
