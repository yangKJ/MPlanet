//
//  UITableViewCell+Ext.swift
//  ProductLib
//
//  Created by Condy on 2024/5/20.
//

import Foundation

extension UITableViewCell {
    fileprivate static var fy_table_view_cell_identifier: String {
        String(describing: self)
    }
}

extension BoxWrapper where Base: UITableViewCell {
    
    public static var identifier: String {
        Base.fy_table_view_cell_identifier
    }
    
    public var identifier: String {
        String(describing: base)
    }
}
