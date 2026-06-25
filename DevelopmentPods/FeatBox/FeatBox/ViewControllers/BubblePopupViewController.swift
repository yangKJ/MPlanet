//
//  BubblePopupViewController.swift
//  FeatBox
//
//  Created by Condy on 2024/5/20.
//

import Foundation
import SnapKit
import ProductLib

/// 解释弹窗
public final class BubblePopupViewController: BaseViewController<BaseViewModel> {
    
    private let width: CGFloat = 200
    
    /// 一行长度自适应
    public var lineLengthDdaptive: Bool = false
    
    public var backgroundColor: UIColor = UIColor.fy.black_333333.withAlphaComponent(0.8) {
        didSet {
            self.popoverPresentationController?.backgroundColor = backgroundColor
        }
    }
    
    public func show(text: String?, from view: UIView, arrowDirection: UIPopoverArrowDirection = .up) {
        guard let content = text else {
            return
        }
        contentLabel.text = content
        self.preferredContentSize = setupContentSize(content: content)
        self.setupArrowDirection(arrowDirection, from: view)
        self.popoverPresentationController?.sourceView = view
        self.popoverPresentationController?.sourceRect = CGRect(origin: .zero, size: view.size)
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
        self.modalPresentationStyle = .popover
        self.popoverPresentationController?.backgroundColor = backgroundColor
        self.popoverPresentationController?.delegate = self
        
        self.view.backgroundColor = UIColor.clear
        self.view.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-10)
            make.top.equalTo(10 + arrowHeight)
        }
    }
}

extension BubblePopupViewController {
    
    private var arrowHeight: CGFloat {
        return self.popoverPresentationController?.popoverBackgroundViewClass?.arrowHeight() ?? 15
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
    
    private func setupArrowDirection(_ arrowDirection: UIPopoverArrowDirection, from view: UIView) {
        let permittedArrowDirections: UIPopoverArrowDirection = {
            let viewPoint = view.convert(view.center, to: UIWindow.fy.keyWindow())
            if UIScreen.main.bounds.height - viewPoint.y < self.preferredContentSize.height, arrowDirection == .up {
                return .down
            } else if viewPoint.y < self.preferredContentSize.height + UINavigationController.fy.navigationHeight(), arrowDirection == .down {
                return .up
            } else {
                return arrowDirection
            }
        }()
        switch permittedArrowDirections {
        case .up:
            contentLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.bottom.equalTo(-10)
                make.top.equalTo(10 + arrowHeight)
            }
        case .down:
            contentLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.bottom.equalTo(-(10 + arrowHeight))
                make.top.equalTo(10)
            }
        case .left:
            contentLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(15 + arrowHeight)
                make.right.equalTo(-15)
                make.bottom.equalTo(-10)
                make.top.equalTo(10)
            }
        case .right:
            contentLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(15)
                make.right.equalTo(-(15 + arrowHeight))
                make.bottom.equalTo(-10)
                make.top.equalTo(10)
            }
        default:
            contentLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.bottom.equalTo(-10)
                make.top.equalTo(10 + arrowHeight)
            }
        }
        self.popoverPresentationController?.permittedArrowDirections = permittedArrowDirections
    }
}

extension BubblePopupViewController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
