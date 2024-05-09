//
//  BaseLabel.swift
//  FeatBox
//
//  Created by Condy on 2023/5/20.
//

import Foundation
import ProductLib

/// 所有文本都需走该实例，方便后续做统一修改<例如：生僻字，字体大小修改等>
open class BaseLabel: UILabel {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupInit()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        self.setupInit()
    }
    
    private func setupInit() {
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
                super.font = newValue.withSize(size).fy.fixedFont
            } else {
                super.font = newValue
            }
        }
        get {
            return super.font
        }
    }
    
    public var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
}

extension BaseLabel {
    
    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let insets = UIEdgeInsets(top: -textInsets.top, left: -textInsets.left, bottom: -textInsets.bottom, right: -textInsets.right)
        return textRect.inset(by: insets)
    }
    
    open override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
    
    public var leftTextInset: CGFloat {
        get { return textInsets.left }
        set { textInsets.left = newValue }
    }
    
    public var rightTextInset: CGFloat {
        get { return textInsets.right }
        set { textInsets.right = newValue }
    }
    
    public var topTextInset: CGFloat {
        get { return textInsets.top }
        set { textInsets.top = newValue }
    }
    
    public var bottomTextInset: CGFloat {
        get { return textInsets.bottom }
        set { textInsets.bottom = newValue }
    }
}
