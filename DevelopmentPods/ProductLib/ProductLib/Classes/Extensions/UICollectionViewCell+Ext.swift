//
//  UICollectionViewCell+Ext.swift
//  ProductLib
//
//  Created by Condy on 2024/5/20.
//

import Foundation

extension UICollectionViewCell {
    fileprivate static var fy_collection_view_cell_identifier: String {
        String(describing: self)
    }
}

extension BoxWrapper where Base: UICollectionViewCell {
    
    public static var identifier: String {
        Base.fy_collection_view_cell_identifier
    }
    
    public var identifier: String {
        String(describing: base)
    }
}
