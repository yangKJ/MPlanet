//
//  MineUsersHeaderCell.swift
//  WMMine
//
//  Created by Condy on 2023/6/6.
//

import Foundation
import FeatBox

class MineUsersHeaderCell: BaseTableViewCell, HasDisposeBag {
    
    public let users = PublishRelay<MineUsers?>()
    
    public let signInEvent = PublishRelay<Void>()
    
    lazy var headerImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.fy.cornerRadius = 30
        imageView.fy.borderPxwidthAndColor(UIColor.fy.white, px: 5)
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = BaseLabel.init()
        label.font = UIFont.fy.system_18
        label.textColor = UIColor.fy.white
        return label
    }()
    
    lazy var starNoteLabel: UILabel = {
        let label = BaseLabel.init()
        label.font = UIFont.fy.system_18
        label.textColor = UIColor.fy.white
        return label
    }()
    
    lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.fy.white
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame.size = view.frame.size
        view.addSubview(blurView)
        return view
    }()
    
    lazy var signInButton: UIButton = {
        var button = BaseButton.init()
        button.setTitle(Res.text("签到"), for: .normal)
        button.setTitleColor(UIColor.fy.white, for: .normal)
        button.fy.cornerRadius = 5
        button.fy.borderPxwidthAndColor(UIColor.fy.white, px: 1.0)
        button.rx.tap.bind(to: signInEvent).disposed(by: rx.disposeBag)
        return button
    }()
    
    lazy var dynamicNewsLabel: UILabel = {
        let label = BaseLabel.init()
        label.font = UIFont.fy.system_18
        label.textColor = UIColor.fy.white
        return label
    }()
    
    override func setupConstraint() {
        backgroundColor = UIColor.fy.mainColor
        contentView.addSubview(headerImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(starNoteLabel)
        contentView.addSubview(line)
        contentView.addSubview(signInButton)
        headerImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(60)
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(headerImageView.snp.right).offset(15)
            make.top.equalTo(headerImageView.snp.top).offset(5)
        }
        starNoteLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
        line.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headerImageView.snp.bottom).offset(15)
            make.height.equalTo(CGFloat.fy.px1)
        }
        signInButton.snp.makeConstraints { make in
            make.centerY.equalTo(headerImageView.snp.centerY)
            make.right.equalToSuperview().offset(-40)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
    }
    
    override func setupBindings() {
        users.subscribe(onNext: { [weak self] in
            self?.nameLabel.text = $0?.name
            if let starNote = $0?.starNote {
                self?.starNoteLabel.text = Res.text("星币：") + starNote
            }
            self?.headerImageView.fy.setImage(with: $0?.avatar_url)
        }).disposed(by: rx.disposeBag)
    }
}
