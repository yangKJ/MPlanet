//
//  UICollectionView+Ext.swift
//  FeatBox
//
//  Created by Condy on 2023/5/20.
//

import Foundation

extension UICollectionViewCell: ReuseIdentifiable { }

extension BoxWrapper where Base: UICollectionView {
    
    public func register<T: UICollectionViewCell>(_ type: T.Type) {
        base.register(type, forCellWithReuseIdentifier: type.reuseIdentifier)
    }
    
    public func dequeueReusableCell<T: UICollectionViewCell>(_ type: T.Type = T.self, for indexPath: IndexPath) -> T {
        let item = base.dequeueReusableCell(withReuseIdentifier: type.reuseIdentifier, for: indexPath)
        guard item.isKind(of: T.self) else {
            fatalError("Cell class must be subclass of BaseCollectionViewCell")
        }
        return item as! T
    }
    
    public func dequeueReusableCell<T: UICollectionViewCell>(_ type: T.Type = T.self, for row: Int) -> T {
        let indexPath = IndexPath.init(index: row)
        let item = base.dequeueReusableCell(withReuseIdentifier: type.reuseIdentifier, for: indexPath)
        guard item.isKind(of: T.self) else {
            fatalError("Cell class must be subclass of BaseCollectionViewCell")
        }
        return item as! T
    }
}
