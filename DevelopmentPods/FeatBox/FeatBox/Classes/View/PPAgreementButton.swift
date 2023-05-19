//
//  PPAgreementButton.swift
//  FeatBox
//
//  Created by Condy on 2022/4/27.
//

import Foundation
import YYText
import SnapKit
import Rickenbacker
import Cabinets

public struct PPAgreement {
    public var title: String?
    public var name: String?
    public var minReadTime: Double?
}

/// 协议控件，例如：我已阅读并同意《某某某协议》
open class PPAgreementButton: UIView {
    private let yyLabel = YYLabel()
    
    private var agreementTapBlock: (([PPAgreement], Int) -> Void)?
    public func setAgreementTapBlock(agreementTapBlock: (([PPAgreement], Int) -> Void)?) {
        self.agreementTapBlock = agreementTapBlock
    }
    
    private var agreementChangeBlock: ((Bool) -> Void)?
    public func setAgreementChangeBlock(agreementChangeBlock: ((Bool) -> Void)?) {
        self.agreementChangeBlock = agreementChangeBlock
    }
    
    private var agreementShouldChangeBlock: ((Bool) -> Bool)?
    public func setAgreementShouldChangeBlock(agreementShouldChangeBlock: ((Bool) -> Bool)?) {
        self.agreementShouldChangeBlock = agreementShouldChangeBlock
    }
    
    public var isChecked: Bool = false {
        didSet {
            refresh()
            agreementChangeBlock?(isChecked)
        }
    }
    
    public var agreements = [PPAgreement]() {
        didSet { refresh() }
    }
    
    public var needMakeSure = false {
        didSet { refresh() }
    }
    
    public var multipleDesc: String? {
        didSet { refresh() }
    }
    
    public var protocolPrefix: String? {
        didSet { refresh() }
    }
    
    public var customDesc: String? {
        didSet { refresh() }
    }
    
    public var selectedIcon: UIImage = R.image("base_blue_selected") {
        didSet { refresh() }
    }
    
    public var unSelectedIcon: UIImage = R.image("base_blue_unselected") {
        didSet { refresh() }
    }
    
    public var textColor: UIColor = UIColor.ao.black {
        didSet { refresh() }
    }
    
    public var linkColor: UIColor = UIColor.ao.blue {
        didSet { refresh() }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public func height(of width: CGFloat) -> CGFloat {
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let layout = YYTextLayout.init(containerSize: size, text: yyLabel.attributedText ?? NSAttributedString())
        return layout?.textBoundingSize.height ?? 0
    }
}

extension PPAgreementButton {
    
    private func setup() {
        isChecked = false
        yyLabel.numberOfLines = 0
        yyLabel.lineBreakMode = .byTruncatingTail
        addSubview(yyLabel)
        yyLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    @objc private func agreementTap(index: Int) {
        agreementTapBlock?(agreements, index)
    }
    
    @objc private func outTap() {
        if needMakeSure {
            if isChecked, agreementShouldChangeBlock?(isChecked) ?? true {
                isChecked = !isChecked
            } else if agreements.count == 1 {
                agreementTapBlock?(agreements, 0)
            }
        } else if agreementShouldChangeBlock?(isChecked) ?? true {
            isChecked = !isChecked
        }
    }
    
    private func refresh() {
        let prefix = " " + (protocolPrefix ?? ("我已阅读并同意"))
        let attributeText0 = NSMutableAttributedString.yy_attachmentString(withContent: isChecked ? selectedIcon : unSelectedIcon,
                                                                           contentMode: .center,
                                                                           attachmentSize: CGSize(width: 20, height: 20),
                                                                           alignTo: UIFont.systemFont(ofSize: 13),
                                                                           alignment: .center)
        attributeText0.yy_setTextHighlight(NSMakeRange(0, attributeText0.string.count), color: textColor, backgroundColor: UIColor.ao.clear) { [weak self] (_,_,_,_) in
            self?.outTap()
        }
        let attributeText1 = NSMutableAttributedString(string: prefix, color: textColor, font: UIFont.systemFont(ofSize: 14))
        attributeText1.yy_setTextHighlight(NSMakeRange(0, prefix.count), color: textColor, backgroundColor: UIColor.ao.clear) { [weak self] (_,_,_,_) in
            self?.outTap()
        }
        let attributeText2: NSMutableAttributedString = {
            var suffix: String? = nil
            if agreements.count > 1 {
                if multipleDesc?.count ?? 0 > 0 {
                    suffix = multipleDesc
                } else {
                    let attributedString = NSMutableAttributedString()
                    agreements.enumerated().forEach { (index, agreement) in
                        let name = "《" + (agreement.name ?? "") + "》"
                        let text = NSMutableAttributedString(string: name, color: linkColor, font: UIFont.systemFont(ofSize: 14))
                        text.yy_setTextHighlight(NSMakeRange(0, name.count), color: linkColor, backgroundColor: UIColor.ao.clear) { [weak self] (_,_,_,_) in
                            self?.agreementTap(index: index)
                        }
                        attributedString.append(text)
                        if index < agreements.count - 1 {
                            attributedString.append(NSMutableAttributedString(string: "、", color: textColor, font: UIFont.systemFont(ofSize: 14)))
                        }
                    }
                    return attributedString
                }
            } else if let agreement = agreements.first {
                suffix = ("《") + (agreement.name ?? "") + ("》")
            } else {
                if customDesc?.count ?? 0 > 0 {
                    suffix = customDesc
                } else {
                    suffix = nil
                }
            }
            if let suffix = suffix {
                let text = NSMutableAttributedString(string: suffix, color: linkColor, font: UIFont.systemFont(ofSize: 14))
                text.yy_setTextHighlight(NSMakeRange(0, suffix.count), color: linkColor, backgroundColor: UIColor.ao.clear) { [weak self] (_,_,_,_) in
                    self?.agreementTap(index: 0)
                }
                return text
            }
            return NSMutableAttributedString()
        }()
        attributeText0.yy_lineSpacing = 5
        attributeText1.yy_lineSpacing = 5
        attributeText2.yy_lineSpacing = 5
        let attributeText = NSMutableAttributedString()//attributeText0 + attributeText1 + attributeText2
        attributeText.append(attributeText0)
        attributeText.append(attributeText1)
        attributeText.append(attributeText2)
        yyLabel.attributedText = attributeText
        agreements.forEach { (agreement) in
            if !needMakeSure, (agreement.minReadTime ?? 0) > 0 {
                needMakeSure = true
            }
        }
    }
}

extension NSAttributedString {
    convenience init(string: String, color: UIColor, font: UIFont, lineSpace: CGFloat? = nil, baseLineOffset: CGFloat? = nil) {
        var attributes = [NSAttributedString.Key: Any]()
        attributes[NSAttributedString.Key.foregroundColor] = color
        attributes[NSAttributedString.Key.font] = font
        if let lineSpace = lineSpace {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpace
            attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        }
        if let baseLineOffset = baseLineOffset {
            attributes[NSAttributedString.Key.baselineOffset] = baseLineOffset
        }
        self.init(string: string, attributes: attributes)
    }
}
