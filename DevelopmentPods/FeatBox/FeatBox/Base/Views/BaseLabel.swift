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
    
    private var fontSize: CGFloat?
    private weak var originalFont: UIFont?
    
//    open override var font: UIFont! {
//        set {
//            if originalFont == nil {
//                self.originalFont = font
//            }
//            if closedAdjustsFontSizeToFitWidth {
//                return
//            }
//            guard let font_ = newValue else {
//                return
//            }
//            fontSize = font_.pointSize
//            if let size = fontSize {
//                super.font = font_.withSize(size).fy.fixedFont
//            } else {
//                super.font = font_
//            }
//        }
//        get {
//            return super.font
//        }
//    }
    
    /// 关闭后不再自动调整文字尺寸以适应控件
    public var closedAdjustsFontSizeToFitWidth: Bool = true {
        didSet {
            if closedAdjustsFontSizeToFitWidth {
                if let oldFont = self.originalFont {
                    self.font = oldFont
                }
            } else {
                // 最小缩为原先的四分子一
                self.minimumScaleFactor = 0.25
            }
            // 动态调整文字尺寸适配控件，只会缩小不会放大
            self.adjustsFontSizeToFitWidth = !closedAdjustsFontSizeToFitWidth
        }
    }
    
    public var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    public func height(of width: CGFloat, font: UIFont? = nil) -> CGFloat {
        guard let text = text, !text.isEmpty else {
            return 0.0
        }
        return text.fy.height(withConstrainedWidth: width, font: font ?? self.font)
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
