//
//  MineSignInCalendarCell.swift
//  WMMine
//
//  Created by Condy on 2023/9/28.
//

import Foundation
import SnapKit
import FeatBox

class MineSignInCalendarCell: FSCalendarViewCellable, Storyboardable {
    
    typealias Element = MineSignInCalendarDTO
    
    func setupDatasource(_ datasource: MineSignInCalendarDTO?) {
        guard let model = datasource, let tagType = model.tag, !self.isPlaceholder else {
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
        let label = BaseLabel.init()
        return label
    }()
    
    lazy var subTagLabel: UILabel = {
        let label = BaseLabel.init()
        return label
    }()
    
    lazy var selectionLayer: CAShapeLayer = {
        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = UIColor.fy.black.cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        return selectionLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        //self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)

        let view = BaseView(frame: self.bounds)
        view.backgroundColor = UIColor.fy.black_333333.withAlphaComponent(0.12)
        self.backgroundView = view

        self.shapeLayer.isHidden = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // Storyboardable 子类不支持 Storyboard 加载,统一错误入口
        StoryboardableFatal.notImplemented(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundView?.frame = self.bounds.insetBy(dx: 1, dy: 1)
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        if self.isPlaceholder {
            self.eventIndicator.isHidden = true
            self.titleLabel.textColor = UIColor.fy.clear
        } else {
            self.titleLabel.textColor = UIColor.fy.black_333333
        }
        self.titleLabel.font = UIFont.fy.system_14
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
