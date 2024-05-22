//
//  UITableView+Ext.swift
//  FeatBox
//
//  Created by Condy on 2023/5/20.
//

import Foundation

extension BoxWrapper where Base: UITableView {
    
    public func register<T: UITableViewCell>(_ type: T.Type) {
        base.register(type, forCellReuseIdentifier: T.fy.identifier)
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(_ type: T.Type) -> T {
        if let cell = base.dequeueReusableCell(withIdentifier: T.fy.identifier) as? T {
            return cell
        }
        return T.init(style: .default, reuseIdentifier: T.fy.identifier)
    }
}
