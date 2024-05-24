//
//  SignatureViewController.swift
//  FeatBox
//
//  Created by Condy on 2023/5/20.
//

import Foundation
import SnapKit
import Rickenbacker
import ProductLib
import RxSwift

public final class SignatureViewController: BaseViewController<BaseViewModel>, NavigationBarHiddenable {
    
    private var imageBase64Block: ((_ base64: String) -> Void)?
    public func setImageBase64Block(block: @escaping ((_ base64: String) -> Void)) {
        self.imageBase64Block = block
    }
    
    let drawEvent: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    var failedError: Error? {
        didSet {
            if let error = failedError {
                self.view.fy.showHUD(title: error.localizedDescription) { alert in
                    alert?.fy.rotation90()
                }
            }
        }
    }
    
    lazy var signatureView: SignatureView = {
        let view = SignatureView.init()
        view.lineWidth = 5
        view.lineColor = UIColor.fy.black
        view.backgroundColor = UIColor.fy.gray_F3F3F3
        view.setDrawBlock { [weak self] isDrawed in
            self?.drawEvent.accept(isDrawed)
        }
        return view
    }()
    
    lazy var backButton: UIButton = {
        let button = BaseButton.init(type: .custom)
        button.fy.rotation90()
        button.setImage(Res.black_back_arrow, for: .normal)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = BaseLabel.init()
        label.fy.rotation90()
        label.text = Res.text("电子签名")
        label.font = UIFont.fy.system_20
        label.textColor = UIColor.fy.title
        return label
    }()
    
    lazy var tipLabel: UILabel = {
        let label = BaseLabel.init()
        label.fy.rotation90()
        label.text = Res.text("请工整的书写以下文字")
        label.font = UIFont.fy.system_16
        label.textColor = UIColor.fy.gray_CCCCCC
        return label
    }()
    
    lazy var placeholderLabel: UILabel = {
        let label = BaseLabel.init()
        label.fy.rotation90()
        //label.text = Res.text("测试文字").fy.insert(between: " ")
        label.font = UIFont.boldSystemFont(ofSize: 120)
        label.textColor = UIColor.fy.gray_999999.withAlphaComponent(0.3)
        label.textAlignment = .center
        return label
    }()
    
    lazy var rewriteButton: UIButton = {
        let button = BaseButton.init(type: .custom)
        button.fy.rotation90()
        button.setTitle(Res.text("重写"), for: .normal)
        button.backgroundColor = UIColor.fy.mainColor
        button.titleLabel?.font = UIFont.fy.bold_18
        button.setTitleColor(UIColor.fy.white, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    lazy var agreeButton: UIButton = {
        let button = BaseButton.init(type: .custom)
        button.fy.rotation90()
        button.setTitle(Res.text("同意"), for: .normal)
        button.backgroundColor = UIColor.fy.mainColor
        button.titleLabel?.font = UIFont.fy.bold_18
        button.setTitleColor(UIColor.fy.white, for: .normal)
        button.addTarget(self, action: #selector(agreeAction), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.fy.white
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
            make.top.equalToSuperview().offset(15.0.fy.addTopSafeArea)
            make.bottom.equalToSuperview().offset(-30)
        }
        self.backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15.0.fy.addTopSafeArea)
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
        self.view.fy.showHUD(title: Res.text("模拟加载ing.."), afterDelay: 5) { alert in
            alert?.fy.rotation90()
        }
        self.screenshotAndMatting(signatureView: signatureView, complete: { [weak self] base64 in
            guard let base64 = base64 else {
                self?.view.fy.showHUD(title: Res.text("您未签署您的姓名，请签署后提交"), alertCallback: { alert in
                    alert?.fy.rotation90()
                })
                return
            }
            self?.imageBase64Block?(base64)
        })
    }
    
    // 截图扣除字体以外部分
    private func screenshotAndMatting(signatureView: SignatureView, complete: (String?) -> Void) {
        guard signatureView.isSigned,
              let image = signatureView.saveSignToImage(),
              let img = imageByMakingWhiteBackgroundTransparent(image: image) else {
            complete(nil)
            return
        }
        let cropImage = img.fy.cropAlpha()
        let rotatedImage = rotate(cropImage, degrees: -90)
        let base64 = rotatedImage.pngData()?.base64EncodedString()
        complete(base64)
    }
    
    /// 白色背景透明化，色值在[222...255]之间均可祛除
    /// The white background is transparent, and the color value can be removed between [222...255].
    private func imageByMakingWhiteBackgroundTransparent(image: UIImage) -> UIImage? {
        // RGB color range to mask (make transparent) R-Low, R-High, G-Low, G-High, B-Low, B-High
        let colorMasking: [CGFloat] = [222, 255, 222, 255, 222, 255]
        return transparentColor(image, colorMasking: colorMasking)
    }
    
    /// Transparent background.
    /// - Parameters:
    ///   - colorMasking: RGB color range to mask [R-Low, R-High, G-Low, G-High, B-Low, B-High]
    ///   - compressionQuality: Compression ratio.
    /// - Returns: Remove the picture of the background.
    private func transparentColor(_ base: UIImage, colorMasking: [CGFloat], compressionQuality: CGFloat = 1.0) -> UIImage? {
        UIGraphicsBeginImageContext(base.size)
        guard let maskedImageRef = base.cgImage?.copy(maskingColorComponents: colorMasking) else {
            return nil
        }
        let rect = CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0.0, y: base.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.draw(maskedImageRef, in: rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    /// Rotate the picture.
    /// - Parameter degrees: Rotation angle.
    /// - Returns: The picture after rotation.
    private func rotate(_ base: UIImage, degrees: Float) -> UIImage {
        let radians = CGFloat(degrees) / 180.0 * .pi
        let tran = CGAffineTransform(rotationAngle: radians)
        var size = CGRect(origin: .zero, size: base.size).applying(tran).size
        size.width  = floor(size.width)
        size.height = floor(size.height)
        let rect = CGRect(x: -base.size.width/2, y: -base.size.height/2, width: base.size.width, height: base.size.height)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: size.width/2, y: size.height/2)
        context?.rotate(by: radians)
        base.draw(in: rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result ?? base
    }
}
