//
//  WalletHomeAssetCell.swift
//  WMWallet
//
//  Created by Condy on 2021/1/19.
//

import UIKit
import FeatBox
import Database

/// 我的资产Item
class WalletHomeAssetCell: UITableViewCell, HasDisposeBag {
    
    var walletData: WalletData? {
        didSet {
            guard let walletData = walletData else { return }
            assetLabel.text = walletData.asset
        }
    }
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.cdy.background
        view.layer.cornerRadius = 25
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.cdy.blue
        view.layer.cornerRadius = 25
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var myAssetTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.cdy.itemTitle
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.text = R.text("我的资产（$）")
        return label
    }()
    
    lazy var eyeButton: UIButton = {
        let button = UIButton.init(type: .custom)
        return button
    }()
    
    lazy var assetLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.cdy.itemTitle
        label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        label.textAlignment = .left
        return label
    }()
    
    lazy var detailsButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitleColor(UIColor.cdy.itemTitle, for: .normal)
        button.setTitle(R.text("查看详情"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 14.5
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.cdy.itemTitle.cgColor
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = UIColor.cdy.background
        setupConstraint()
        setupBindings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraint() {
        contentView.addSubview(backView)
        backView.addSubview(iconImageView)
        iconImageView.addSubview(myAssetTitleLabel)
        iconImageView.addSubview(assetLabel)
        iconImageView.addSubview(eyeButton)
        iconImageView.addSubview(detailsButton)
        backView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView).inset(16)
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-12)
        }
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(140)
        }
        myAssetTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.left.equalToSuperview().offset(17)
        }
        eyeButton.snp.makeConstraints { make in
            make.left.equalTo(myAssetTitleLabel.snp.right).offset(10.5)
            make.centerY.equalTo(myAssetTitleLabel.snp.centerY)
        }
        assetLabel.snp.makeConstraints { make in
            make.top.equalTo(myAssetTitleLabel.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(17)
        }
        detailsButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-21.5)
            make.left.equalToSuperview().offset(17)
            make.width.equalTo(92)
            make.height.equalTo(29)
        }
    }
    
    func setupBindings() {
        
    }
}

extension Reactive where Base: WalletHomeAssetCell {
    
    /// 点击查看详情
    var tapDetails: Observable<Void> {
        return Observable.create({ [weak base] (observer) in
            if let base = base {
                base.detailsButton.rx.tap.subscribe(onNext: {
                    observer.onNext(())
                })
            } else {
                observer.onCompleted()
            }
            return Disposables.create()
        }).takeUntil(deallocated)
    }
}
