//
//  BaseCollectionViewCell.swift
//  FeatBox
//
//  Created by Condy on 2023/5/20.
//

import Foundation
import ProductLib

open class BaseCollectionViewCell: UICollectionViewCell, Identifierable {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.fy.background
        self.setupConstraint()
        self.setupBindings()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = UIColor.fy.background
        self.setupConstraint()
        self.setupBindings()
    }
    
    // MARK: - 子类实现
    open func setupConstraint() {
        
    }
    
    open func setupBindings() {
        
    }
}
