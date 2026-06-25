//
//  UITableView+Ext.swift
//  FeatBox
//
//  Created by Condy on 2023/5/20.
//

import Foundation

extension UITableViewCell: ReuseIdentifiable { }
extension UITableViewHeaderFooterView: ReuseIdentifiable { }

extension BoxWrapper where Base: UITableView {
    
    public func register<T: UITableViewCell>(_ type: T.Type) {
        base.register(type, forCellReuseIdentifier: type.reuseIdentifier)
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(_ type: T.Type = T.self, for row: Int) -> T {
        dequeueReusableCell(type, for: IndexPath.init(index: row))
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(_ type: T.Type = T.self, for indexPath: IndexPath) -> T {
        let identifier = type.reuseIdentifier
        if let cell = base.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T {
            return cell
        }
        let cell = T.init(style: .default, reuseIdentifier: identifier)
        cell.prepareForReuse()
        cell.contentView.autoresizingMask = .flexibleHeight
        cell.contentView.translatesAutoresizingMaskIntoConstraints = true
        return cell
    }
    
    public func register<T: UITableViewHeaderFooterView>(headerFooterViewClass: T.Type) {
        base.register(headerFooterViewClass, forHeaderFooterViewReuseIdentifier: headerFooterViewClass.reuseIdentifier)
    }
    
    public func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_ type: T.Type) -> T? {
        guard let headerFooterView = base.dequeueReusableHeaderFooterView(withIdentifier: type.reuseIdentifier) as? T? else {
            fatalError("Could not dequeue header/footer view.")
        }
        //T.init(reuseIdentifier: type.reuseIdentifier)
        return headerFooterView
    }
}
