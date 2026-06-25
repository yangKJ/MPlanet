//
//  BannerDetailCell.swift
//  WMDiscover
//
//  Created by Condy on 2023/5/31.
//

import Foundation
import FeatBox

class BannerDetailCellViewModel: BaseTableViewCellViewModelable {
    var cellType: FeatBox.BaseTableViewCell.Type {
        BannerDetailCell.self
    }
}

class BannerDetailCell: BaseTableViewCell {
    
    override var viewModel: BaseTableViewCellViewModelable? {
        didSet {
            guard let viewModel = viewModel as? BannerDetailCellViewModel,
                  let datasource = viewModel.datasource as? BannerDetail else {
                return
            }
            //self.backView.backgroundColor = datasource.background?.peel
            self.heightConstraint_?.update(offset: datasource.height ?? 300)
        }
    }
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.fy.mainColor
        view.layer.cornerRadius = 25
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private var heightConstraint_: Constraint?
    
    override func setupConstraint() {
        contentView.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
            self.heightConstraint_ = make.height.equalTo(300).constraint
        }
    }
}
