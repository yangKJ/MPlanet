//
//  WalletHomeApplicationCell.swift
//  WMWallet
//
//  Created by Condy on 2021/1/19.
//

import UIKit
import FeatBox

/// 小工具应用Item
class WalletHomeApplicationCell: BaseTableViewCell {
    
    var applicationDatas: [WalletApplicationData]? {
        didSet {
            
        }
    }
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ai.background
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
