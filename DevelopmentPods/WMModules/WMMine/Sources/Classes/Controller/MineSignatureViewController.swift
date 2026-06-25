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
        // 美化：按钮字体升级 bold_18，呼应主操作
        button.titleLabel?.font = UIFont.fy.bold_18
        button.setTitleColor(UIColor.fy.white, for: .normal)
        // 美化：渐变背景（主色绿 → 主色绿 0.78）
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.fy.mainColor.cgColor,
            UIColor.fy.mainColor.withAlphaComponent(0.78).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        UIGraphicsBeginImageContextWithOptions(gradient.bounds.size, false, 0)
        gradient.render(in: UIGraphicsGetCurrentContext()!)
        let bgImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        button.setBackgroundImage(bgImage, for: .normal)
        button.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
        // 美化：圆角 8 → 10，按钮更柔和
        button.layer.cornerRadius = 10
        // 美化：轻投影，让按钮浮起来
        button.layer.shadowColor = UIColor.fy.mainColor.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 6
        return button
    }()

    lazy var base64Label: UILabel = {
        let label = BaseLabel.init()
        // 美化：正文降为 system_15，可读且不抢主按钮
        label.font = UIFont.fy.system_15
        label.textColor = UIColor.fy.black_333333
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
        // 美化：页面背景统一为 backgroundGray
        self.view.backgroundColor = UIColor.fy.backgroundGray
        self.view.addSubview(tapButton)
        self.view.addSubview(base64Label)
        self.tapButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(100)
        }
        self.base64Label.snp.makeConstraints { make in
            make.top.equalTo(self.tapButton.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.lessThanOrEqualTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-24)
        }
    }
    
    @objc func tapAction() {
        let auth = SignatureAuthVerification()
        auth.navigationController = self.navigationController
        auth.setWillCloseByUserBlock { _ in
            print("pop")
        }
        auth.startDestinationAction(destinationActionWhenUICompletion: true, action: { [weak self] base64 in
            self?.base64Label.text = base64
        })
    }
}
