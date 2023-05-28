//
//  BaseCollectionViewCell.swift
//  FeatBox
//
//  Created by Condy on 2023/5/20.
//

import Foundation
import Extensions

open class BaseCollectionViewCell: UICollectionViewCell, Identifierable {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.ai.background
        self.setupConstraint()
        self.setupBindings()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 子类实现
    open func setupConstraint() {
        
    }
    
    open func setupBindings() {
        
    }
}
