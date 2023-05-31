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
        view.backgroundColor = UIColor.ai.mainColor
        view.layer.cornerRadius = 25
        view.isUserInteractionEnabled = true
        return view
    }()
    
    override func setupConstraint() {
        contentView.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
            make.height.equalTo(1000)
        }
    }
    
    override func setupBindings() {
        detail.subscribe(onNext: { [weak self] in
            self?.backView.backgroundColor = $0?.background
        }).disposed(by: rx.disposeBag)
    }
}
