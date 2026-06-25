//
//  UITableView+Ext.swift
//  FeatBox
//
//  Created by Condy on 2024/5/20.
//

import Foundation
import ProductLib
import MJRefresh
import UITableView_FDTemplateLayoutCell

extension BoxWrapper where Base: UITableView {
    
    public func heightForRowAt<T: UITableViewCell>(_ indexPath: IndexPath,
                                                   cellClass: T.Type,
                                                   configuration: ((T) -> Void)? = nil) -> CGFloat {
        // https://blog.sunnyxx.com/2015/05/17/cell-height-calculation/
        return base.fd_heightForCell(withIdentifier: cellClass.reuseIdentifier, cacheBy: indexPath, configuration: { cell in
            guard let cell = cell as? T else {
                fatalError("Could not convert cell.")
            }
            configuration?(cell)
        })
    }
    
    public var tableHeaderViewWithoutHeightChange: UIView? {
        set {
            base.tableHeaderView = newValue
            if let header = self.base.header {
                header.superview?.bringSubviewToFront(header)
            }
        }
        get {
            return base.tableHeaderView
        }
    }
    
    public var tableHeaderView: UIView? {
        set {
            base.tableHeaderView = newValue
            guard var header = newValue else {
                return
            }
            header.setNeedsLayout()
            header.layoutIfNeeded()
            header.fy.height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            base.tableHeaderView = header
            if let header = self.base.mj_header {
                header.superview?.bringSubviewToFront(header)
            }
        }
        get {
            return base.tableHeaderView
        }
    }
    
    public var tableFooterView: UIView? {
        set {
            base.tableFooterView = newValue
            guard var footer = newValue else {
                return
            }
            footer.setNeedsLayout()
            footer.layoutIfNeeded()
            footer.fy.height = footer.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            base.tableFooterView = footer
            if let footer = self.base.mj_footer {
                footer.superview?.bringSubviewToFront(footer)
            }
        }
        get {
            return base.tableFooterView
        }
    }
}
