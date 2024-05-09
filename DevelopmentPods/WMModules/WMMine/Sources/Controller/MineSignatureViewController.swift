//
//  MineSignatureViewController.swift
//  WMMine
//
//  Created by Condy on 2023/8/30.
//

import Foundation
import SnapKit
import FeatBox

/// 测试验证签名信息
class MineSignatureViewController: BaseViewController<BaseViewModel> {
    
    lazy var tapButton: UIButton = {
        let button = BaseButton.init(type: .custom)
        button.setTitle(Res.text("签名"), for: .normal)
        button.titleLabel?.font = UIFont.fy.system_16
        button.setTitleColor(UIColor.fy.mainColor, for: .normal)
        button.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.fy.mainColor.cgColor
        return button
    }()
    
    lazy var base64Label: UILabel = {
        let label = BaseLabel.init()
        label.font = UIFont.fy.system_20
        label.textColor = UIColor.fy.title
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInit()
        self.setupUI()
    }
    
    func setupInit() {
        self.title = Res.text("测试验证签名信息")
    }
    
    func setupUI() {
        self.view.addSubview(tapButton)
        self.view.addSubview(base64Label)
        self.tapButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(80)
        }
        self.base64Label.snp.makeConstraints { make in
            make.top.equalTo(self.tapButton.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.lessThanOrEqualToSuperview().offset(-40)
        }
    }
    
    @objc func tapAction() {
        let auth = SignatureAuthVerfication()
        auth.navigationController = self.navigationController
        auth.setWillCloseByUserBlock { _ in
            print("pop")
        }
        auth.startDestinationAction(destinationActionWhenUICompletion: true, action: { [weak self] base64 in
            self?.base64Label.text = base64
        })
    }
}
