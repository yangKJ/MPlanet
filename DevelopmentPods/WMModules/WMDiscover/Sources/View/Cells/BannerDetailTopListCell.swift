//
//  BannerDetailTopListCell.swift
//  WMDiscover
//
//  Created by Condy on 2023/5/29.
//

import Foundation
import FeatBox

class BannerDetailTopListCell: BaseTableViewCell {
    
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
            make.leading.trailing.equalTo(contentView).inset(16)
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-12)
        }
    }
}
