//
//  CustomButton.swift
//  FeatBox
//
//  Created by Condy on 2023/5/20.
//

import Foundation
import Extensions
import UIKit

/// 所有按钮都需走该实例，方便后续做统一修改
open class CustomButton: UIButton {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    private func setupInit() {
        
    }
}
