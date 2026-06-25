//
//  CXTitleHeaderFooterView.swift
//  FeatBox
//
//  Created by Condy on 2024/5/20.
//

import Foundation
import ProductLib
import SnapKit

public struct CXTitleHeaderFooterConfig {
    
    public var titleFont: UIFont = UIFont.fy.system_16
    public var titleColor: UIColor = UIColor.fy.title
    
    public var accessoryImage: UIImage?
    public var accessoryText: String?
    public var accessoryTitleFont: UIFont = UIFont.fy.system_14
    public var accessoryTitleColor: UIColor = UIColor.fy.detailTitle
    
    public var hasLine: Bool = false
    public var lineColor: UIColor = UIColor.fy.line
    public var lineHeight: CGFloat = CGFloat.fy.px1
}

public final class CXTitleHeaderFooterViewModel: BaseTableViewSectionable {
    
    public var sectionHeaderTitleFont: UIFont = UIFont.fy.system_16
    public var sectionFooterTitleFont: UIFont = UIFont.fy.system_16
    
    public var sectionHeaderTitleColor: UIColor = UIColor.fy.title
    public var sectionFooterTitleColor: UIColor = UIColor.fy.title
    
    public var sectionHeaderAccessoryImage: UIImage?
    public var sectionFooterAccessoryImage: UIImage?
    
    public var sectionHeaderAccessoryText: String?
    public var sectionFooterAccessoryText: String?
    
    public var sectionHeaderAccessoryTitleFont: UIFont = UIFont.fy.system_14
    public var sectionFooterAccessoryTitleFont: UIFont = UIFont.fy.system_14
    
    public var sectionHeaderAccessoryTitleColor: UIColor = UIColor.fy.detailTitle
    public var sectionFooterAccessoryTitleColor: UIColor = UIColor.fy.detailTitle
    
    public var sectionHeaderLineColor: UIColor?
    public var sectionFooterLineColor: UIColor?
    public var sectionHeaderLineHeight: CGFloat = CGFloat.fy.px1
    public var sectionFooterLineHeight: CGFloat = CGFloat.fy.px1
    
    public var cells: [BaseTableViewCellViewModelable] = []
    
    public init(cells: [BaseTableViewCellViewModelable]) {
        self.cells = cells
    }
    
    fileprivate var sectionTitleTapBlock: ((BaseTableViewHeaderFooterView.ViewType) -> Void)?
    public func setSectionTitleTap(block: @escaping ((BaseTableViewHeaderFooterView.ViewType) -> Void)) {
        self.sectionTitleTapBlock = block
    }
    
    fileprivate var accessoryTapBlock: ((BaseTableViewHeaderFooterView.ViewType) -> Void)?
    public func setAccessoryTap(block: @escaping (BaseTableViewHeaderFooterView.ViewType) -> Void) {
        self.accessoryTapBlock = block
    }
}

public final class CXTitleHeaderFooterView: BaseTableViewHeaderFooterView {
    
    private lazy var titleLabel: BaseLabel = {
        let label = BaseLabel.init(frame: .zero)
        label.textColor = UIColor.fy.title
        label.font = UIFont.fy.system_16
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapTitleClick))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        return label
    }()
    
    private lazy var accessoryImageButton: UIButton = {
        let button = BaseButton(frame: .zero)
        button.contentHorizontalAlignment = .right
        button.sizeToFit()
        button.addTarget(self, action: #selector(tapAccessoryImageClick), for: .touchUpInside)
        return button
    }()
    
    lazy var line: ZLineView = {
        let view = ZLineView(asix: .horizontal, thickness: 1.0)
        //view.backgroundColor = UIColor.fy.line
        return view
    }()
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    public override func refreshViews() {
        super.refreshViews()
        guard let sectionViewModel = sectionViewModel as? CXTitleHeaderFooterViewModel else {
            return
        }
        switch type {
        case .header:
            self.titleLabel.text = sectionViewModel.sectionHeaderTitle
            self.titleLabel.font = sectionViewModel.sectionHeaderTitleFont
            self.titleLabel.textColor = sectionViewModel.sectionHeaderTitleColor
            self.accessoryImageButton.titleLabel?.font = sectionViewModel.sectionHeaderAccessoryTitleFont
            self.accessoryImageButton.setTitle(sectionViewModel.sectionHeaderAccessoryText, for: .normal)
            self.accessoryImageButton.setTitleColor(sectionViewModel.sectionHeaderAccessoryTitleColor, for: .normal)
            self.accessoryImageButton.setImage(sectionViewModel.sectionHeaderAccessoryImage, for: .normal)
            self.line.backgroundColor = sectionViewModel.sectionHeaderLineColor
            self.line.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.left.right.equalToSuperview()
                make.height.equalTo(sectionViewModel.sectionHeaderLineHeight)
            }
        case .footer:
            self.titleLabel.text = sectionViewModel.sectionFooterTitle
            self.titleLabel.font = sectionViewModel.sectionFooterTitleFont
            self.titleLabel.textColor = sectionViewModel.sectionFooterTitleColor
            self.accessoryImageButton.titleLabel?.font = sectionViewModel.sectionFooterAccessoryTitleFont
            self.accessoryImageButton.setTitle(sectionViewModel.sectionFooterAccessoryText, for: .normal)
            self.accessoryImageButton.setTitleColor(sectionViewModel.sectionFooterAccessoryTitleColor, for: .normal)
            self.accessoryImageButton.setImage(sectionViewModel.sectionFooterAccessoryImage, for: .normal)
            self.line.backgroundColor = sectionViewModel.sectionFooterLineColor
            self.line.snp.remakeConstraints { make in
                make.bottom.equalToSuperview()
                make.left.right.equalToSuperview()
                make.height.equalTo(sectionViewModel.sectionFooterLineHeight)
            }
        }
    }
    
    private func setupViews() {
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.accessoryImageButton)
        self.contentView.addSubview(self.line)
        self.titleLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(accessoryImageButton.snp.left).offset(-5)
        }
        self.accessoryImageButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-15).priority(999)
        }
    }
    
    @objc private func tapTitleClick(_ tap: UIGestureRecognizer) {
        guard let viewModel = sectionViewModel as? CXTitleHeaderFooterViewModel else {
            return
        }
        viewModel.sectionTitleTapBlock?(type)
    }
    
    @objc private func tapAccessoryImageClick(_ sender: UIButton) {
        guard let viewModel = sectionViewModel as? CXTitleHeaderFooterViewModel else {
            return
        }
        viewModel.accessoryTapBlock?(type)
    }
}
