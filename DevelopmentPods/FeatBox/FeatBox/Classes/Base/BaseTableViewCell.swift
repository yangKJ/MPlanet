//
//  BaseTableViewCell.swift
//  FeatBox
//
//  Created by Condy on 2023/5/20.
//

import Foundation
import Extensions

open class BaseTableViewCell: UITableViewCell, Identifierable {
    
    public required override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
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
