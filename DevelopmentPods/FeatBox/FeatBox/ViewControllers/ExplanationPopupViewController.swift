//
//  ExplanationPopupViewController.swift
//  FeatBox
//
//  Created by Condy on 2024/5/20.
//

import Foundation
import SnapKit
import ProductLib

/// 解释弹窗
public final class ExplanationPopupViewController: BaseViewController<BaseViewModel> {
    private let width: CGFloat = 200
    
    public var content: String? {
        didSet {
            guard let content = content else {
                return
            }
            contentLabel.text = content
            self.preferredContentSize = setupContentSize(content: content)
        }
    }
    
    /// 一行长度自适应
    public var lineLengthDdaptive: Bool = false
    
    public var arrowDirection: UIPopoverArrowDirection = .up {
        didSet {
            let height = self.popoverPresentationController?.popoverBackgroundViewClass?.arrowHeight() ?? 15
            switch arrowDirection {
            case .up:
                contentLabel.snp.remakeConstraints { (make) in
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
                    make.bottom.equalTo(-10)
                    make.top.equalTo(10 + height)
                }
            case .down:
                contentLabel.snp.remakeConstraints { (make) in
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
                    make.bottom.equalTo(-(10 + height))
                    make.top.equalTo(10)
                }
            case .left:
                contentLabel.snp.remakeConstraints { (make) in
                    make.left.equalTo(15 + height)
                    make.right.equalTo(-15)
                    make.bottom.equalTo(-10)
                    make.top.equalTo(10)
                }
            case .right:
                contentLabel.snp.remakeConstraints { (make) in
                    make.left.equalTo(15)
                    make.right.equalTo(-(15 + height))
                    make.bottom.equalTo(-10)
                    make.top.equalTo(10)
                }
            default:
                contentLabel.snp.remakeConstraints { (make) in
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
                    make.bottom.equalTo(-10)
                    make.top.equalTo(10 + height)
                }
            }
            self.popoverPresentationController?.permittedArrowDirections = arrowDirection
        }
    }
    
    public var sourceView: UIView? {
        didSet {
            self.popoverPresentationController?.sourceView = sourceView
            self.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: sourceView?.bounds.size.width ?? 0, height: sourceView?.bounds.size.height ?? 0)
        }
    }
    
    private lazy var contentLabel: BaseLabel = {
        let label = BaseLabel.init()
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.backgroundColor = UIColor.fy.clear
        label.font = UIFont.fy.system_13
        label.textColor = UIColor.fy.white
        return label
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInit()
        self.setupUI()
    }
    
    private func setupInit() {
        self.modalPresentationStyle = .popover
        self.popoverPresentationController?.backgroundColor = UIColor.fy.gray_333333.withAlphaComponent(0.9)
        self.popoverPresentationController?.delegate = self
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.fy.clear
        view.addSubview(contentLabel)
        let height = self.popoverPresentationController?.popoverBackgroundViewClass?.arrowHeight() ?? 15
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-10)
            make.top.equalTo(10 + height)
        }
    }
    
    private func setupContentSize(content: String) -> CGSize {
        if lineLengthDdaptive {
            let textSize = CGSize(width: CGFloat(MAXFLOAT), height: 10)
            let textWidth = content.fy.boundingRect(with: textSize, font: contentLabel.font).width
            if textWidth <= width {
                return CGSize(width: textWidth + 15 + 25, height: 10 + CGFloat(10 + 25))
            }
        }
        let textSize = CGSize(width: width, height: CGFloat(MAXFLOAT))
        let textHeight = content.fy.boundingRect(with: textSize, font: contentLabel.font).height
        return CGSize(width: width + 15 + 15, height: textHeight + CGFloat(10 + 25))
    }
}

extension ExplanationPopupViewController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
