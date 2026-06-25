//
//  BaseTableViewHeaderFooterView.swift
//  FeatBox
//
//  Created by Condy on 2024/5/20.
//

import Foundation
import ProductLib
import SnapKit

open class BaseTableViewHeaderFooterView: UITableViewHeaderFooterView {
    
    public enum ViewType {
        case header
        case footer
    }
    
    public var type: ViewType = .header
    
    public var sectionViewModel: BaseTableViewSectionable? {
        didSet {
            self.refreshViews()
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    open func refreshViews() {
        switch type {
        case .header:
            self.contentView.backgroundColor = sectionViewModel?.sectionHeaderBackgroundColor ?? UIColor.fy.gray_F7F7F7
            self.backgroundView?.backgroundColor = sectionViewModel?.sectionHeaderBackgroundColor ?? UIColor.fy.gray_F7F7F7
        case .footer:
            self.contentView.backgroundColor = sectionViewModel?.sectionFooterBackgroundColor ?? UIColor.fy.gray_F7F7F7
            self.backgroundView?.backgroundColor = sectionViewModel?.sectionFooterBackgroundColor ?? UIColor.fy.gray_F7F7F7
        }
    }
    
    private func setupViews() {
        self.backgroundView = UIView()
        self.contentView.backgroundColor = UIColor.fy.gray_F7F7F7
        self.backgroundView?.backgroundColor = UIColor.fy.gray_F7F7F7
    }
}
