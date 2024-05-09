//
//  View+SnapKit.swift
//  FeatBox
//
//  Created by Condy on 2023/5/20.
//

import Foundation
import SnapKit

extension UIView {
    /// 令宽度等于常数
    @discardableResult public func width(_ const: CGFloat) -> UIView {
        self.snp.makeConstraints {
            $0.width.equalTo(const)
        }
        return self
    }
    
    /// 令高度等于常数
    @discardableResult public func height(_ const: CGFloat) -> UIView {
        self.snp.makeConstraints {
            $0.height.equalTo(const)
        }
        return self
    }
    
    /// 令宽度、高度等于 CGSize
    @discardableResult public func size(_ size: CGSize) -> UIView {
        self.snp.makeConstraints {
            $0.width.equalTo(size.width)
            $0.height.equalTo(size.height)
        }
        return self
    }
    
    /// 令宽高比等于常数
    @discardableResult public func ratio(_ const: CGFloat) -> UIView {
        self.snp.makeConstraints {
            $0.width.equalTo(self.snp.height).multipliedBy(const)
        }
        return self
    }
    
    /// 令左边贴紧父控件，可指定边距
    @discardableResult public func left(_ inset: CGFloat = 0) -> UIView {
        self.snp.makeConstraints {
            $0.left.equalToSuperview().offset(inset)
        }
        return self
    }
    
    /// 令右边贴紧父控件，可指定边距
    @discardableResult public func right(_ inset: CGFloat = 0) -> UIView {
        self.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-inset)
        }
        return self
    }
    
    /// 令上边贴紧父控件，可指定边距
    @discardableResult public func top(_ inset: CGFloat = 0) -> UIView {
        self.snp.makeConstraints {
            $0.top.equalToSuperview().offset(inset)
        }
        return self
    }
    
    /// 令下边贴紧父控件，可指定边距
    @discardableResult public func bottom(_ inset: CGFloat = 0) -> UIView {
        self.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-inset)
        }
        return self
    }
    
    /// 令四边贴紧父控件，可指定边距
    @discardableResult public func insets(_ inset: UIEdgeInsets) -> UIView {
        self.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(inset)
        }
        return self
    }
    
    /// 令宽度等于父控件宽度
    @discardableResult public func width() -> UIView {
        self.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
        return self
    }
    
    /// 令高度等于父控件高度
    @discardableResult public func height() -> UIView {
        self.snp.makeConstraints {
            $0.height.equalToSuperview()
        }
        return self
    }
    
    /// 与父控件左右居中对齐，可指定偏移，右移为正，左移为负
    @discardableResult public func centerX(_ offset: CGFloat = 0) -> UIView {
        self.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(offset)
        }
        return self
    }
    
    /// 与父控件上下居中对齐，可指定偏移，下移为正，上移为负
    @discardableResult public func centerY(_ offset: CGFloat = 0) -> UIView {
        self.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(offset)
        }
        return self
    }
    
    /// 与父控件居中对齐，可指定偏移，右下移为正，左上移为负
    @discardableResult public func center(_ offsetX: CGFloat = 0, _ offsetY: CGFloat = 0) -> UIView {
        self.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(offsetX)
            $0.centerY.equalToSuperview().offset(offsetY)
        }
        return self
    }
    
    /// 令左边与另一控件左边对齐，可指定偏移，右移为正，左移为负
    @discardableResult public func left(_ view: UIView, _ offset: CGFloat = 0) -> UIView {
        self.snp.makeConstraints {
            $0.left.equalTo(view).offset(offset)
        }
        return self
    }
    
    /// 令右边与另一控件右边对齐，可指定偏移，右移为正，左移为负
    @discardableResult public func right(_ view: UIView, _ offset: CGFloat = 0) -> UIView {
        self.snp.makeConstraints {
            $0.right.equalTo(view).offset(offset)
        }
        return self
    }
    
    /// 令上边与另一控件上边对齐，可指定偏移，下移为正，上移为负
    @discardableResult public func top(_ view: UIView, _ offset: CGFloat = 0) -> UIView {
        self.snp.makeConstraints {
            $0.top.equalTo(view).offset(offset)
        }
        return self
    }
    
    /// 令下边与另一控件下边对齐，可指定偏移，下移为正，上移为负
    @discardableResult public func bottom(_ view: UIView, _ offset: CGFloat = 0) -> UIView {
        self.snp.makeConstraints {
            $0.bottom.equalTo(view).offset(offset)
        }
        return self
    }
    
    /// 令宽度与另一控件相等，可指定比例系数
    @discardableResult public func width(_ view: UIView, _ multiplier: CGFloat = 1) -> UIView {
        self.snp.makeConstraints {
            $0.width.equalTo(view).multipliedBy(multiplier)
        }
        return self
    }
    
    /// 令高度与另一控件相等，可指定比例系数
    @discardableResult public func height(_ view: UIView, _ multiplier: CGFloat = 1) -> UIView {
        self.snp.makeConstraints {
            $0.height.equalTo(view).multipliedBy(multiplier)
        }
        return self
    }
    
    /// 与另一控件左右居中对齐，可指定偏移，右移为正，左移为负
    @discardableResult public func centerX(_ view: UIView, _ offset: CGFloat = 0) -> UIView {
        self.snp.makeConstraints {
            $0.centerX.equalTo(view).offset(offset)
        }
        return self
    }
    
    /// 与另一控件上下居中对齐，可指定偏移，下移为正，上移为负
    @discardableResult public func centerY(_ view: UIView, _ offset: CGFloat = 0) -> UIView {
        self.snp.makeConstraints {
            $0.centerY.equalTo(view).offset(offset)
        }
        return self
    }
    
    /// 紧接在另一控件右侧，可指定间距
    @discardableResult public func after(_ view: UIView, _ spacing: CGFloat = 0) -> UIView {
        self.snp.makeConstraints {
            $0.left.equalTo(view.snp.right).offset(spacing)
        }
        return self
    }
    
    /// 紧接在另一控件左侧，可指定间距
    @discardableResult public func before(_ view: UIView, _ spacing: CGFloat = 0) -> UIView {
        self.snp.makeConstraints {
            $0.right.equalTo(view.snp.left).offset(-spacing)
        }
        return self
    }
    
    /// 紧接在另一控件下方，可指定间距
    @discardableResult public func below(_ view: UIView, _ spacing: CGFloat = 0) -> UIView {
        self.snp.makeConstraints {
            $0.top.equalTo(view.snp.bottom).offset(spacing)
        }
        return self
    }
    
    /// 紧接在另一控件上方，可指定间距
    @discardableResult public func above(_ view: UIView, _ spacing: CGFloat = 0) -> UIView {
        self.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.top).offset(-spacing)
        }
        return self
    }
    
    /// 向上撑起父控件，即令控件上边至少在父控件上边的下方
    @discardableResult public func inflateUp(_ inset: CGFloat = 0) -> UIView {
        self.snp.makeConstraints {
            $0.top.greaterThanOrEqualToSuperview().offset(inset)
        }
        return self
    }
    
    /// 向上撑起父控件，即令控件下边至少在父控件下边的上方
    @discardableResult public func inflateDown(_ inset: CGFloat = 0) -> UIView {
        self.snp.makeConstraints {
            $0.bottom.lessThanOrEqualToSuperview().offset(-inset)
        }
        return self
    }
    
    /// 向左撑起父控件，即令控件左边至少在父控件左边的右方
    @discardableResult public func inflateLeft(_ inset: CGFloat = 0) -> UIView {
        self.snp.makeConstraints {
            $0.left.greaterThanOrEqualToSuperview().offset(inset)
        }
        return self
    }
    
    /// 向右撑起父控件，即令控件右边至少在父控件右边的左方
    @discardableResult public func inflateRight(_ inset: CGFloat = 0) -> UIView {
        self.snp.makeConstraints {
            $0.right.lessThanOrEqualToSuperview().offset(-inset)
        }
        return self
    }
    
    /// 自动向下排列，即自动寻找父控件中上一个控件，紧贴在其下方，并自动向下撑起父控件
    @discardableResult public func flowDown(_ spacing: CGFloat = 0) -> UIView {
        let lastView = superview?.subviews.filter { $0 != self }.last
        if let lastView = lastView {
            below(lastView, spacing)
        } else {
            top()
        }
        inflateDown()
        return self
    }
    
    /// 自动向右排列，即自动寻找父控件中上一个控件，紧贴在其右方，并自动向右撑起父控件
    @discardableResult public func flowRight(_ spacing: CGFloat = 0) -> UIView {
        let lastView = superview?.subviews.filter { $0 != self }.last
        if let lastView = lastView {
            after(lastView, spacing)
        } else {
            left()
        }
        inflateRight()
        return self
    }
}

//extension BoxWrapper where Base: UIView {
//
//    /// 自动向下排列，即自动寻找父控件中上一个控件，紧贴在其下方，并自动向下撑起父控件
//    @discardableResult public func flowDown(_ spacing: CGFloat = 0) -> UIView {
//        let lastView = base.superview?.subviews.filter { $0 != base }.last
//        if let lastView = lastView {
//            base.snp.makeConstraints { make in
//                make.left.equalTo(lastView.snp.bottom).offset(spacing)
//                make.bottom.lessThanOrEqualToSuperview()
//            }
//        } else {
//            base.snp.makeConstraints { make in
//                make.top.equalToSuperview()
//                make.bottom.lessThanOrEqualToSuperview()
//            }
//        }
//        return base
//    }
//
//    /// 自动向右排列，即自动寻找父控件中上一个控件，紧贴在其右方，并自动向右撑起父控件
//    @discardableResult public func flowRight(_ spacing: CGFloat = 0) -> UIView {
//        let lastView = base.superview?.subviews.filter { $0 != base }.last
//        if let lastView = lastView {
//            base.snp.makeConstraints { make in
//                make.left.equalTo(lastView.snp.right).offset(spacing)
//                make.right.lessThanOrEqualToSuperview()
//            }
//        } else {
//            base.snp.makeConstraints { make in
//                make.left.equalToSuperview()
//                make.right.lessThanOrEqualToSuperview()
//            }
//        }
//        return base
//    }
//}
