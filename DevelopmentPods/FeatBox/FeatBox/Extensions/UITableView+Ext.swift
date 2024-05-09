//
//  UITableView+Ext.swift
//  FeatBox
//
//  Created by Condy on 2023/5/20.
//

import Foundation
import UITableView_FDTemplateLayoutCell

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
    
    /// UITableView自动计算Cell高度，高度缓存
    public func heightForRow<T: BaseTableViewCell>(_ type: T.Type, indexPath: IndexPath, configuration: @escaping (T) -> Void) -> CGFloat {
        return base.fd_heightForCell(withIdentifier: T.identifier, cacheBy: indexPath, configuration: { (cell) in
            guard let cell = cell as? T else {
                fatalError("Could not convert cell.")
            }
            configuration(cell)
        })
    }
}
