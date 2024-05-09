//
//  MineSignInCalenderCell.swift
//  WMMine
//
//  Created by Condy on 2023/9/28.
//

import Foundation
import SnapKit
import FeatBox

class MineSignInCalenderCell: FSCalendarViewCellable {
    
    typealias Element = MineSignInCalenderModel
    
    func setupDatasource(_ datasource: MineSignInCalenderModel?) {
        guard let model = datasource, let tagType = model.tagEnum, !self.isPlaceholder else {
            self.tagLabel.isHidden = true
            self.subTagLabel.isHidden = true
            return
        }
        self.tagLabel.isHidden = false
        self.subTagLabel.isHidden = false
        self.tagLabel.font = tagType.titleFont
        self.subTagLabel.font = tagType.subTitleFont
        self.tagLabel.textColor = tagType.titleColor
        self.subTagLabel.textColor = tagType.subTitleColor
        self.tagLabel.text = tagType.title
        self.subTagLabel.text = tagType.subTitle
    }
    
    lazy var tagLabel: UILabel = {
        let label = UILabel.init()
        return label
    }()
    
    lazy var subTagLabel: UILabel = {
        let label = UILabel.init()
        return label
    }()
    
    lazy var selectionLayer: CAShapeLayer = {
        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = UIColor.black.cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        return selectionLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        //self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)

        let view = UIView(frame: self.bounds)
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.12)
        self.backgroundView = view
        
        self.shapeLayer.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundView?.frame = self.bounds.insetBy(dx: 1, dy: 1)
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        if self.isPlaceholder {
            self.eventIndicator.isHidden = true
            self.titleLabel.textColor = UIColor.clear
        } else {
            self.titleLabel.textColor = UIColor.init(hex: 333333)
        }
        self.titleLabel.font = UIFont.systemFont(ofSize: 14)
    }
    
    func setupUI() {
        self.contentView.addSubview(tagLabel)
        self.contentView.addSubview(subTagLabel)
        tagLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(5)
            //make.top.equalTo(titleLabel.snp.bottom).offset(2)
        }
        subTagLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(tagLabel.snp.bottom).offset(2)
        }
    }
}
