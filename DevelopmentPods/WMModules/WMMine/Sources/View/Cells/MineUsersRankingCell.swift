//
//  MineUsersRankingCell.swift
//  WMMine
//
//  Created by Condy on 2023/6/6.
//

import Foundation
import FeatBox

class MineUsersRankingCell: BaseTableViewCell, HasDisposeBag {
    
    public var name: String? {
        didSet {
            self.titleLabel.text = name
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = BaseLabel.init()
        label.font = UIFont.fy.system_18
        label.textColor = UIColor.fy.white
        return label
    }()
    
    lazy var arrow: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Res.image("")
        return imageView
    }()
    
    override func setupConstraint() {
        self.lineHeight.accept(10)
        backgroundColor = UIColor.fy.mainColor
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrow)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(15)
        }
        arrow.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.left.equalToSuperview().offset(-15)
        }
    }
    
    override func setupBindings() {
        
    }
}
