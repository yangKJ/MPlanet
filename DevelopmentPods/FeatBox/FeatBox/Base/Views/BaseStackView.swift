//
//  BaseStackView.swift
//  FeatBox
//
//  Created by Condy on 2023/10/11.
//

import Foundation

open class BaseStackView: UIStackView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupInit()
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupInit()
    }
    
    private func setupInit() {
        spacing = 8
        axis = .vertical
    }
}
