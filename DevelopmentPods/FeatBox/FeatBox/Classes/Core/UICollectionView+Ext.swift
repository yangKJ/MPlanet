//
//  UICollectionView+Ext.swift
//  FeatBox
//
//  Created by Condy on 2023/5/20.
//

import Foundation
import Extensions

extension BoxWrapper where Base: UICollectionView {
    
    public func register<T: BaseCollectionViewCell>(_ type: T.Type) {
        base.register(type, forCellWithReuseIdentifier: T.identifier)
    }
    
    public func dequeueReusableCell<T: BaseCollectionViewCell>(_ type: T.Type, indexPath: IndexPath) -> T {
        let item = base.dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath)
        guard item.isKind(of: T.self) else {
            fatalError("Cell class must be subclass of BaseCollectionViewCell")
        }
        return item as! T
    }
    
    public func dequeueReusableCell<T: BaseCollectionViewCell>(_ type: T.Type, row: Int) -> T {
        let indexPath = IndexPath.init(index: row)
        let item = base.dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath)
        guard item.isKind(of: T.self) else {
            fatalError("Cell class must be subclass of BaseCollectionViewCell")
        }
        return item as! T
    }
}
