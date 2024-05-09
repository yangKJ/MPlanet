//
//  MineFunctionFormCell.swift
//  WMMine
//
//  Created by Condy on 2023/6/6.
//

import FeatBox

class MineFunctionFormCell: BaseTableViewCell {
    
    public let functionForm = PublishRelay<MineFunctionForm>()
    
    lazy var titleLabel: UILabel = {
        let label = BaseLabel.init()
        label.font = UIFont.fy.system_16
        label.textColor = UIColor.fy.title
        return label
    }()
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            var frame = newValue
            frame.origin.x += 15
            frame.size.width -= 2 * 15
            super.frame = frame
        }
    }
    
    override func setupConstraint() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
    }
    
    override func setupBindings() {
        functionForm.subscribe(onNext: { [weak self] in
            self?.titleLabel.text = $0.des
        }).disposed(by: rx.disposeBag)
    }
}
