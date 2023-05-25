//
//  SignatureViewController.swift
//  WMDiscover
//
//  Created by Condy on 2023/5/16.
//

import Foundation
import FeatBox

class SignatureViewController: BaseViewController, NavigationBarHiddenable {
    
    private var agreeBlock: ((_ userSignInfo: String?) -> Void)?
    func setAgreeBlock(block: @escaping ((_ userSignInfo: String?) -> Void)) {
        self.agreeBlock = block
    }
    
    let drawEvent: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    lazy var signatureView: AVSignatureView = {
        let view = AVSignatureView.init()
        view.lineWidth = 5
        view.lineColor = UIColor.ai.black
        view.backgroundColor = UIColor.ai.gray_F3F3F3
        view.setDrawBlock { [weak self] isDrawed in
            self?.drawEvent.accept(isDrawed)
        }
        return view
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.ai.rotation90()
        button.setImage(R.image("back"), for: .normal)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.ai.rotation90()
        label.text = R.text("电子签名")
        label.font = UIFont.ai.system_20
        label.textColor = UIColor.ai.title
        return label
    }()
    
    lazy var tipLabel: UILabel = {
        let label = UILabel.init()
        label.ai.rotation90()
        label.text = R.text("请工整的书写以下文字")
        label.font = UIFont.ai.system_16
        label.textColor = UIColor.ai.gray_CCCCCC
        label.textAlignment = .right
        return label
    }()
    
    lazy var placeholderLabel: UILabel = {
        let label = UILabel.init()
        label.ai.rotation90()
        label.text = R.text("测试文字")
        label.font = UIFont.ai.boldSystemFont(ofSize: 108)
        label.textColor = UIColor.ai.gray_999999.withAlphaComponent(0.3)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    lazy var rewriteButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.ai.rotation90()
        button.setTitle(R.text("重写"), for: .normal)
        button.backgroundColor = UIColor.ai.red.withAlphaComponent(0.5)
        button.titleLabel?.font = UIFont.ai.bold_18
        button.setTitleColor(UIColor.ai.white, for: .normal)
        return button
    }()
    
    lazy var agreeButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.ai.rotation90()
        button.setTitle(R.text("同意"), for: .normal)
        button.backgroundColor = UIColor.ai.red.withAlphaComponent(0.5)
        button.titleLabel?.font = UIFont.ai.bold_18
        button.setTitleColor(UIColor.ai.white, for: .normal)
        button.addTarget(self, action: #selector(agreeAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.ai.white
        self.setupUI()
        self.setupBinding()
    }
    
    var agreeBottomConstraint: Constraint?
    var agreeLeftConstraint: Constraint?
    
    func setupUI() {
        self.view.addSubview(signatureView)
        self.view.addSubview(backButton)
        self.view.addSubview(titleLabel)
        self.view.addSubview(rewriteButton)
        self.view.addSubview(agreeButton)
        self.view.addSubview(placeholderLabel)
        self.view.addSubview(tipLabel)
        self.signatureView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(80)
            make.right.equalToSuperview().offset(-60)
            make.top.equalToSuperview().offset(15.0.ai.addTopSafeArea)
            make.bottom.equalToSuperview().offset(-30)
        }
        self.backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15.0.ai.addTopSafeArea)
            make.right.equalToSuperview().offset(-25)
            make.width.height.equalTo(20)
        }
        self.titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalTo(backButton)
        }
        self.tipLabel.snp.makeConstraints { make in
            make.top.equalTo(signatureView).offset(15+50)
            make.right.equalTo(signatureView).offset(20+50)
            make.width.equalTo(200)
        }
        self.placeholderLabel.snp.makeConstraints { make in
            make.center.equalTo(signatureView.snp.center)
            make.width.lessThanOrEqualTo(signatureView.snp.height)
        }
        self.agreeButton.snp.makeConstraints { make in
            self.agreeBottomConstraint = make.bottom.equalTo(signatureView).constraint
            self.agreeLeftConstraint = make.left.equalToSuperview().offset(20).constraint
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
        self.rewriteButton.snp.makeConstraints { make in
            make.bottom.equalTo(agreeButton.snp.top).offset(-20-60)
            make.left.equalTo(agreeButton)
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
        
        self.agreeBottomConstraint?.update(offset: -35)
        self.agreeLeftConstraint?.update(offset: 20-35)
        self.view.layoutIfNeeded()
    }
    
    func setupBinding() {
        // 返回
        self.backButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.backAction()
        }).disposed(by: rx.disposeBag)
        
        // 重写
        self.rewriteButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.signatureView.clearSign()
        }).disposed(by: rx.disposeBag)
        
        // 绘制中
        self.drawEvent.bind(to: self.tipLabel.rx.isHidden).disposed(by: rx.disposeBag)
        self.drawEvent.bind(to: self.placeholderLabel.rx.isHidden).disposed(by: rx.disposeBag)
    }
    
    @objc func agreeAction() {
        if self.signatureView.isSigned {
            screenshotAndMatting { [weak self] image in
                guard let image = image else {
                    return
                }
                self?.backAction()
                let base64 = image.pngData()?.base64EncodedString()
                self?.agreeBlock?(base64)
            }
        } else {
            self.view.ai.showHUD(title: R.text("您未签署您的姓名，请签署后提交"), alertCallback: { alert in
                alert?.ai.rotation90()
            })
        }
    }
    
    // 截图扣除字体以外部分
    private func screenshotAndMatting(complete: (_ image: UIImage?) -> Void) {
        guard let image = self.signatureView.saveSignToImage(),
              let img = image.ai.imageByMakingWhiteBackgroundTransparent(),
              let cgImage = img.cgImage else {
            complete(nil)
            return
        }
        let rotatedImage = UIImage.init(cgImage: cgImage, scale: image.scale, orientation: .left)
        complete(rotatedImage)
    }
}
