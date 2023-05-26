//
//  DynamicFontSizeLabel.swift
//  FeatBox
//
//  Created by Condy on 2023/5/20.
//

import Foundation
import Extensions

/// 所有文本都需走该实例，方便后续做统一修改<例如：生僻字，字体大小修改等>
open class DynamicFontSizeLabel: UILabel {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupInit()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInit() {
        // 动态调整文字尺寸适配控件，只会缩小不会放大
        self.adjustsFontSizeToFitWidth = true
        // 最小缩为原先的四分子一
        self.minimumScaleFactor = 0.25
    }
    
    private var fontSize: CGFloat?
    
    open override var font: UIFont! {
        set {
            fontSize = newValue.pointSize
            if let size = fontSize {
                super.font = newValue.withSize(size).ai.fixedFont
            } else {
                super.font = newValue
            }
        }
        get {
            return super.font
        }
    }
}
