//
//  WalletHomeTokenCell.swift
//  WMWallet
//
//  Created by Condy on 2021/1/19.
//

import UIKit
import FeatBox
import Database

/// 代币列表Item
class WalletHomeTokenCell: UITableViewCell {
    
    var tokenData: WalletTokenData? {
        didSet {
            guard let tokenData = tokenData else { return }
            titleLabel.text = tokenData.chainName
            amountLabel.text = tokenData.amount
            unitLabel.text = tokenData.unit
        }
    }
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.cdy.background
        view.layer.cornerRadius = 15
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.cdy.blue
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.cdy.itemTitle
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.cdy.itemTitle
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()
    
    lazy var unitLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.cdy.itemSubTitle
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .right
        return label
    }()
    
    lazy var dollarLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.cdy.itemSubTitle
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = UIColor.cdy.background
        setupConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraint() {
        contentView.addSubview(backView)
        backView.addSubview(iconImageView)
        backView.addSubview(titleLabel)
        backView.addSubview(amountLabel)
        backView.addSubview(unitLabel)
        backView.addSubview(dollarLabel)
        backView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView).inset(16)
            make.top.equalTo(contentView).offset(12)
            make.bottom.equalTo(contentView)
        }
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15.5)
            make.size.equalTo(37)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconImageView.snp.right).offset(14.5)
        }
        unitLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(19)
        }
        amountLabel.snp.makeConstraints { make in
            make.right.equalTo(unitLabel.snp.left).offset(-5)
            make.bottom.equalTo(unitLabel.snp.bottom)
        }
        dollarLabel.snp.makeConstraints { make in
            make.top.equalTo(amountLabel.snp.bottom).offset(7.5)
            make.right.equalToSuperview().offset(-16)
        }
    }
}
