//
//  SignatureViewController.swift
//  WMDiscover
//
//  Created by Condy on 2023/5/16.
//

import Foundation
import FeatBox

class SignatureViewController: BaseViewController<SignatureViewModel>, NavigationBarHiddenable {
    
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
        let button = CustomButton.init(type: .custom)
        button.ai.rotation90()
        button.setImage(R.image("back"), for: .normal)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = DynamicFontSizeLabel.init()
        label.ai.rotation90()
        label.text = R.text("电子签名")
        label.font = UIFont.ai.system_20
        label.textColor = UIColor.ai.title
        return label
    }()
    
    lazy var tipLabel: UILabel = {
        let label = DynamicFontSizeLabel.init()
        label.ai.rotation90()
        label.text = R.text("请工整的书写以下文字")
        label.font = UIFont.ai.system_16
        label.textColor = UIColor.ai.gray_CCCCCC
        return label
    }()
    
    lazy var placeholderLabel: UILabel = {
        let label = DynamicFontSizeLabel.init()
        label.ai.rotation90()
        label.text = R.text("测试文字").ai.insert(between: " ")
        label.font = UIFont.boldSystemFont(ofSize: 120)
        label.textColor = UIColor.ai.gray_999999.withAlphaComponent(0.3)
        label.textAlignment = .center
        return label
    }()
    
    lazy var rewriteButton: UIButton = {
        let button = CustomButton.init(type: .custom)
        button.ai.rotation90()
        button.setTitle(R.text("重写"), for: .normal)
        button.backgroundColor = UIColor.ai.mainColor
        button.titleLabel?.font = UIFont.ai.bold_18
        button.setTitleColor(UIColor.ai.white, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    lazy var agreeButton: UIButton = {
        let button = CustomButton.init(type: .custom)
        button.ai.rotation90()
        button.setTitle(R.text("同意"), for: .normal)
        button.backgroundColor = UIColor.ai.mainColor
        button.titleLabel?.font = UIFont.ai.bold_18
        button.setTitleColor(UIColor.ai.white, for: .normal)
        button.addTarget(self, action: #selector(agreeAction), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.ai.white
        self.setupSubviews()
        self.setupBinding()
    }
    
    var tipTopConstraint: Constraint?
    var tipRightConstraint: Constraint?
    
    func setupSubviews() {
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
            self.tipTopConstraint = make.top.equalTo(signatureView).offset(15).constraint
            self.tipRightConstraint = make.right.equalTo(signatureView).offset(20).constraint
        }
        self.placeholderLabel.snp.makeConstraints { make in
            make.center.equalTo(signatureView.snp.center)
            make.width.lessThanOrEqualTo(signatureView.snp.height)
        }
        self.agreeButton.snp.makeConstraints { make in
            make.bottom.equalTo(signatureView).offset(-35)
            make.left.equalToSuperview().offset(20-35)
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
        self.rewriteButton.snp.makeConstraints { make in
            make.bottom.equalTo(agreeButton.snp.top).offset(-20-60)
            make.left.equalTo(agreeButton)
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
        
        self.tipLabel.layoutIfNeeded()
        let width = self.tipLabel.frame.size.width
        let height = self.tipLabel.frame.size.height
        self.tipTopConstraint?.update(offset: height/4 + width + 20)
        self.tipRightConstraint?.update(offset: height/4 + 20)
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
        //self.drawEvent.bind(to: self.placeholderLabel.rx.isHidden).disposed(by: rx.disposeBag)
    }
    
    @objc func agreeAction() {
        if self.signatureView.isSigned {
            viewModel.screenshotAndTransformUserSignInfo(signatureView: signatureView)
                .subscribe(onNext: { [weak self] userSignInfo in
                    self?.agreeBlock?(userSignInfo)
                    self?.backAction()
                }, onError: {
                    self.view.ai.showHUD(title: $0.localizedDescription)
                }).disposed(by: rx.disposeBag)
        } else {
            self.view.ai.showHUD(title: R.text("您未签署您的姓名，请签署后提交"), alertCallback: { alert in
                alert?.ai.rotation90()
            })
        }
    }
}
