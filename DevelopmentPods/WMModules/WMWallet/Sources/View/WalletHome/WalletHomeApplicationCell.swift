//
//  WalletHomeApplicationCell.swift
//  WMWallet
//
//  Created by Condy on 2021/1/19.
//

import UIKit
import FeatBox

/// 小工具应用Item
class WalletHomeApplicationCell: UITableViewCell {
    
    static let identifier = "WalletHomeApplicationCell"
    
    var applicationDatas: [WalletApplicationData]? {
        didSet {
            
        }
    }
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ao.background
        view.layer.cornerRadius = 25
        view.isUserInteractionEnabled = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = UIColor.ao.background
        setupConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraint() {
        contentView.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView).inset(16)
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-12)
        }
    }
}
