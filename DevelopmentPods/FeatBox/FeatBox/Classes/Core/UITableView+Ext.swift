//
//  UITableView+Ext.swift
//  FeatBox
//
//  Created by Condy on 2023/5/20.
//

import Foundation
import Extensions

extension BoxWrapper where Base: UITableView {
    
    public func register<T: BaseTableViewCell>(_ type: T.Type) {
        base.register(type, forCellReuseIdentifier: T.identifier)
    }
    
    public func dequeueReusableCell<T: BaseTableViewCell>(_ type: T.Type) -> T {
        if let cell = base.dequeueReusableCell(withIdentifier: T.identifier) as? T {
            return cell
        }
        return T.init(style: .default, reuseIdentifier: T.identifier)
    }
}
