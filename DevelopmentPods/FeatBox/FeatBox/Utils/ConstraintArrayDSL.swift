//
//  ConstraintArrayDSL.swift
//  FeatBox
//
//  Created by Condy on 2024/5/20.
//

import Foundation
import SnapKit

public struct ConstraintArrayDSL {
    public var target: AnyObject? {
        return self.array as AnyObject
    }
    
    let array: Array<ConstraintView>
    
    init(array: Array<ConstraintView>) {
        self.array = array
    }
    
    @discardableResult
    public func prepareConstraints(_ closure: (_ make: ConstraintMaker) -> Void) -> [Constraint] {
        var constraints = Array<Constraint>()
        for view in self.array {
            constraints.append(contentsOf: view.snp.prepareConstraints(closure))
        }
        return constraints
    }
    
    public func makeConstraints(_ closure: (_ make: ConstraintMaker) -> Void) {
        for view in self.array {
            view.snp.makeConstraints(closure)
        }
    }
    
    public func remakeConstraints(_ closure: (_ make: ConstraintMaker) -> Void) {
        for view in self.array {
            view.snp.remakeConstraints(closure)
        }
    }
    
    public func updateConstraints(_ closure: (_ make: ConstraintMaker) -> Void) {
        for view in self.array {
            view.snp.updateConstraints(closure)
        }
    }
    
    public func removeConstraints() {
        for view in self.array {
            view.snp.removeConstraints()
        }
    }
    
    /// distribute with fixed spacing
    ///
    /// - Parameters:
    ///   - axisType: which axis to distribute items along
    ///   - fixedSpacing: the spacing between each item
    ///   - leadSpacing: the spacing before the first item and the container
    ///   - tailSpacing: the spacing after the last item and the container
    public func distributeViewsAlong(axisType: NSLayoutConstraint.Axis,
                                     fixedSpacing: CGFloat,
                                     leadSpacing: CGFloat = 0,
                                     tailSpacing: CGFloat = 0) {
        guard self.array.count > 1, let tempSuperView = commonSuperviewOfViews() else {
            return
        }
        if axisType == .horizontal {
            var prev: ConstraintView?
            for (i, v) in self.array.enumerated() {
                v.snp.makeConstraints({ (make) in
                    if prev != nil {
                        make.width.equalTo(prev!)
                        make.left.equalTo((prev?.snp.right)!).offset(fixedSpacing)
                        if (i == self.array.count - 1) {//last one
                            make.right.equalTo(tempSuperView).offset(-tailSpacing);
                        }
                    } else {
                        make.left.equalTo(tempSuperView).offset(leadSpacing);
                    }
                })
                prev = v;
            }
        } else {
            var prev : ConstraintView?
            for (i, v) in self.array.enumerated() {
                v.snp.makeConstraints({ (make) in
                    if prev != nil {
                        make.height.equalTo(prev!)
                        make.top.equalTo((prev?.snp.bottom)!).offset(fixedSpacing)
                        if (i == self.array.count - 1) {//last one
                            make.bottom.equalTo(tempSuperView).offset(-tailSpacing);
                        }
                    } else {
                        make.top.equalTo(tempSuperView).offset(leadSpacing);
                    }
                })
                prev = v;
            }
        }
    }
    
    /// distribute with fixed item size
    ///
    /// - Parameters:
    ///   - axisType: which axis to distribute items along
    ///   - fixedItemLength: the fixed length of each item
    ///   - leadSpacing: the spacing before the first item and the container
    ///   - tailSpacing: the spacing after the last item and the container
    public func distributeViewsAlong(axisType: NSLayoutConstraint.Axis,
                                     fixedItemLength: CGFloat,
                                     leadSpacing: CGFloat = 0,
                                     tailSpacing: CGFloat = 0) {
        guard self.array.count > 1, let tempSuperView = commonSuperviewOfViews() else {
            return
        }
        if axisType == .horizontal {
            var prev : ConstraintView?
            for (i, v) in self.array.enumerated() {
                v.snp.makeConstraints({ (make) in
                    make.width.equalTo(fixedItemLength)
                    if prev != nil {
                        if (i == self.array.count - 1) {//last one
                            make.right.equalTo(tempSuperView).offset(-tailSpacing);
                        } else {
                            let offset = (CGFloat(1) - (CGFloat(i) / CGFloat(self.array.count - 1))) *
                            (fixedItemLength + leadSpacing) - CGFloat(i) *
                            tailSpacing /
                            CGFloat(self.array.count - 1)
                            make.right
                                .equalTo(tempSuperView)
                                .multipliedBy(CGFloat(i) / CGFloat(self.array.count - 1))
                                .offset(offset)
                        }
                    } else {
                        make.left.equalTo(tempSuperView).offset(leadSpacing);
                    }
                })
                prev = v;
            }
        } else {
            var prev : ConstraintView?
            for (i, v) in self.array.enumerated() {
                v.snp.makeConstraints({ (make) in
                    make.height.equalTo(fixedItemLength)
                    if prev != nil {
                        if (i == self.array.count - 1) {//last one
                            make.bottom.equalTo(tempSuperView).offset(-tailSpacing);
                        } else {
                            let offset = (CGFloat(1) - (CGFloat(i) / CGFloat(self.array.count - 1))) *
                            (fixedItemLength + leadSpacing) - CGFloat(i) *
                            tailSpacing /
                            CGFloat(self.array.count - 1)
                            
                            make.bottom
                                .equalTo(tempSuperView)
                                .multipliedBy(CGFloat(i) / CGFloat(self.array.count-1))
                                .offset(offset)
                        }
                    } else {
                        make.top.equalTo(tempSuperView).offset(leadSpacing);
                    }
                })
                prev = v;
            }
        }
    }
    
    public func distributeSudokuViews(fixedItemWidth: CGFloat,
                                      fixedItemHeight: CGFloat,
                                      warpCount: Int,
                                      edgeInset: UIEdgeInsets = .zero) {
        guard self.array.count > 1, warpCount >= 1, let tempSuperView = commonSuperviewOfViews() else {
            return
        }
        let rowCount = self.array.count % warpCount == 0 ? self.array.count / warpCount : self.array.count / warpCount + 1;
        let columnCount = warpCount
        for (i,v) in self.array.enumerated() {
            let currentRow = i / warpCount
            let currentColumn = i % warpCount
            v.snp.makeConstraints({ (make) in
                make.width.equalTo(fixedItemWidth)
                make.height.equalTo(fixedItemHeight)
                if currentRow == 0 {//fisrt row
                    make.top.equalTo(tempSuperView).offset(edgeInset.top)
                }
                if currentRow == rowCount - 1 {//last row
                    make.bottom.equalTo(tempSuperView).offset(-edgeInset.bottom)
                }
                if currentRow != 0 && currentRow != rowCount - 1 {//other row
                    let offset = (CGFloat(1) - CGFloat(currentRow) / CGFloat(rowCount - 1)) * (fixedItemHeight + edgeInset.top) - CGFloat(currentRow) * edgeInset.bottom / CGFloat(rowCount - 1)
                    make.bottom
                        .equalTo(tempSuperView)
                        .multipliedBy(CGFloat(currentRow) / CGFloat(rowCount - 1))
                        .offset(offset);
                }
                if currentColumn == 0 {//first col
                    make.left.equalTo(tempSuperView).offset(edgeInset.left)
                }
                if currentColumn == columnCount - 1 {//last col
                    make.right.equalTo(tempSuperView).offset(-edgeInset.right)
                }
                if currentColumn != 0 && currentColumn != columnCount - 1 {//other col
                    let offset = (CGFloat(1) - CGFloat(currentColumn) / CGFloat(columnCount - 1)) * (fixedItemWidth + edgeInset.left) - CGFloat(currentColumn) * edgeInset.right / CGFloat(columnCount - 1)
                    make.right
                        .equalTo(tempSuperView)
                        .multipliedBy(CGFloat(currentColumn) / CGFloat(columnCount - 1))
                        .offset(offset);
                }
            })
        }
    }
    
    public func distributeSudokuViews(fixedLineSpacing: CGFloat,
                                      fixedInteritemSpacing: CGFloat,
                                      warpCount: Int,
                                      edgeInset: UIEdgeInsets = .zero) {
        guard self.array.count > 1, warpCount >= 1, let tempSuperView = commonSuperviewOfViews() else {
            return
        }
        let columnCount = warpCount
        let rowCount = self.array.count % warpCount == 0 ? self.array.count / warpCount : self.array.count / warpCount + 1
        var prev : ConstraintView?
        for (i, v) in self.array.enumerated() {
            let currentRow = i / warpCount
            let currentColumn = i % warpCount
            v.snp.makeConstraints({ (make) in
                if prev != nil {
                    make.width.height.equalTo(prev!)
                }
                if currentRow == 0 {//fisrt row
                    make.top.equalTo(tempSuperView).offset(edgeInset.top)
                }
                if currentRow == rowCount - 1 {//last row
                    if currentRow != 0 && i - columnCount >= 0 {
                        make.top.equalTo(self.array[i-columnCount].snp.bottom).offset(fixedLineSpacing)
                    }
                    make.bottom.equalTo(tempSuperView).offset(-edgeInset.bottom)
                }
                if currentRow != 0 && currentRow != rowCount - 1 {//other row
                    make.top.equalTo(self.array[i-columnCount].snp.bottom).offset(fixedLineSpacing);
                }
                if currentColumn == 0 {//first col
                    make.left.equalTo(tempSuperView).offset(edgeInset.left)
                }
                if currentColumn == warpCount - 1 {//last col
                    if currentColumn != 0 {
                        make.left.equalTo(prev!.snp.right).offset(fixedInteritemSpacing)
                    }
                    make.right.equalTo(tempSuperView).offset(-edgeInset.right)
                }
                
                if currentColumn != 0 && currentColumn != warpCount - 1 {//other col
                    make.left.equalTo(prev!.snp.right).offset(fixedInteritemSpacing);
                }
            })
            prev = v
        }
    }
    
    private func commonSuperviewOfViews() -> ConstraintView? {
        var commonSuperview : ConstraintView?
        var previousView : ConstraintView?
        for view in self.array {
            if previousView != nil {
                commonSuperview = view.closestCommonSuperview(commonSuperview)
            } else {
                commonSuperview = view
            }
            previousView = view
        }
        return commonSuperview
    }
}

private extension ConstraintView {
    func closestCommonSuperview(_ view : ConstraintView?) -> ConstraintView? {
        var closestCommonSuperview: ConstraintView?
        var secondViewSuperview: ConstraintView? = view
        while closestCommonSuperview == nil && secondViewSuperview != nil {
            var firstViewSuperview: ConstraintView? = self
            while closestCommonSuperview == nil && firstViewSuperview != nil {
                if secondViewSuperview == firstViewSuperview {
                    closestCommonSuperview = secondViewSuperview
                }
                firstViewSuperview = firstViewSuperview?.superview
            }
            secondViewSuperview = secondViewSuperview?.superview
        }
        return closestCommonSuperview
    }
}

// MARK: - view Constraints

extension BoxWrapper where Base: UIView {
    /// 令宽度等于常数
    @discardableResult public func width(_ const: CGFloat) -> UIView {
        base.snp.makeConstraints {
            $0.width.equalTo(const)
        }
        return base
    }
    
    /// 令高度等于常数
    @discardableResult public func height(_ const: CGFloat) -> UIView {
        base.snp.makeConstraints {
            $0.height.equalTo(const)
        }
        return base
    }
    
    /// 令宽度、高度等于 CGSize
    @discardableResult public func size(_ size: CGSize) -> UIView {
        base.snp.makeConstraints {
            $0.width.equalTo(size.width)
            $0.height.equalTo(size.height)
        }
        return base
    }
    
    /// 令宽高比等于常数
    @discardableResult public func ratio(_ const: CGFloat) -> UIView {
        base.snp.makeConstraints {
            $0.width.equalTo(base.snp.height).multipliedBy(const)
        }
        return base
    }
    
    /// 令左边贴紧父控件，可指定边距
    @discardableResult public func left(_ inset: CGFloat = 0) -> UIView {
        base.snp.makeConstraints {
            $0.left.equalToSuperview().offset(inset)
        }
        return base
    }
    
    /// 令右边贴紧父控件，可指定边距
    @discardableResult public func right(_ inset: CGFloat = 0) -> UIView {
        base.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-inset)
        }
        return base
    }
    
    /// 令上边贴紧父控件，可指定边距
    @discardableResult public func top(_ inset: CGFloat = 0) -> UIView {
        base.snp.makeConstraints {
            $0.top.equalToSuperview().offset(inset)
        }
        return base
    }
    
    /// 令下边贴紧父控件，可指定边距
    @discardableResult public func bottom(_ inset: CGFloat = 0) -> UIView {
        base.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-inset)
        }
        return base
    }
    
    /// 令四边贴紧父控件，可指定边距
    @discardableResult public func insets(_ inset: UIEdgeInsets) -> UIView {
        base.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(inset)
        }
        return base
    }
    
    /// 令宽度等于父控件宽度
    @discardableResult public func width() -> UIView {
        base.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
        return base
    }
    
    /// 令高度等于父控件高度
    @discardableResult public func height() -> UIView {
        base.snp.makeConstraints {
            $0.height.equalToSuperview()
        }
        return base
    }
    
    /// 与父控件左右居中对齐，可指定偏移，右移为正，左移为负
    @discardableResult public func centerX(_ offset: CGFloat = 0) -> UIView {
        base.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(offset)
        }
        return base
    }
    
    /// 与父控件上下居中对齐，可指定偏移，下移为正，上移为负
    @discardableResult public func centerY(_ offset: CGFloat = 0) -> UIView {
        base.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(offset)
        }
        return base
    }
    
    /// 与父控件居中对齐，可指定偏移，右下移为正，左上移为负
    @discardableResult public func center(_ offsetX: CGFloat = 0, _ offsetY: CGFloat = 0) -> UIView {
        base.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(offsetX)
            $0.centerY.equalToSuperview().offset(offsetY)
        }
        return base
    }
    
    /// 令左边与另一控件左边对齐，可指定偏移，右移为正，左移为负
    @discardableResult public func left(_ view: UIView, _ offset: CGFloat = 0) -> UIView {
        base.snp.makeConstraints {
            $0.left.equalTo(view).offset(offset)
        }
        return base
    }
    
    /// 令右边与另一控件右边对齐，可指定偏移，右移为正，左移为负
    @discardableResult public func right(_ view: UIView, _ offset: CGFloat = 0) -> UIView {
        base.snp.makeConstraints {
            $0.right.equalTo(view).offset(offset)
        }
        return base
    }
    
    /// 令上边与另一控件上边对齐，可指定偏移，下移为正，上移为负
    @discardableResult public func top(_ view: UIView, _ offset: CGFloat = 0) -> UIView {
        base.snp.makeConstraints {
            $0.top.equalTo(view).offset(offset)
        }
        return base
    }
    
    /// 令下边与另一控件下边对齐，可指定偏移，下移为正，上移为负
    @discardableResult public func bottom(_ view: UIView, _ offset: CGFloat = 0) -> UIView {
        base.snp.makeConstraints {
            $0.bottom.equalTo(view).offset(offset)
        }
        return base
    }
    
    /// 令宽度与另一控件相等，可指定比例系数
    @discardableResult public func width(_ view: UIView, _ multiplier: CGFloat = 1) -> UIView {
        base.snp.makeConstraints {
            $0.width.equalTo(view).multipliedBy(multiplier)
        }
        return base
    }
    
    /// 令高度与另一控件相等，可指定比例系数
    @discardableResult public func height(_ view: UIView, _ multiplier: CGFloat = 1) -> UIView {
        base.snp.makeConstraints {
            $0.height.equalTo(view).multipliedBy(multiplier)
        }
        return base
    }
    
    /// 与另一控件左右居中对齐，可指定偏移，右移为正，左移为负
    @discardableResult public func centerX(_ view: UIView, _ offset: CGFloat = 0) -> UIView {
        base.snp.makeConstraints {
            $0.centerX.equalTo(view).offset(offset)
        }
        return base
    }
    
    /// 与另一控件上下居中对齐，可指定偏移，下移为正，上移为负
    @discardableResult public func centerY(_ view: UIView, _ offset: CGFloat = 0) -> UIView {
        base.snp.makeConstraints {
            $0.centerY.equalTo(view).offset(offset)
        }
        return base
    }
    
    /// 紧接在另一控件右侧，可指定间距
    @discardableResult public func after(_ view: UIView, _ spacing: CGFloat = 0) -> UIView {
        base.snp.makeConstraints {
            $0.left.equalTo(view.snp.right).offset(spacing)
        }
        return base
    }
    
    /// 紧接在另一控件左侧，可指定间距
    @discardableResult public func before(_ view: UIView, _ spacing: CGFloat = 0) -> UIView {
        base.snp.makeConstraints {
            $0.right.equalTo(view.snp.left).offset(-spacing)
        }
        return base
    }
    
    /// 紧接在另一控件下方，可指定间距
    @discardableResult public func below(_ view: UIView, _ spacing: CGFloat = 0) -> UIView {
        base.snp.makeConstraints {
            $0.top.equalTo(view.snp.bottom).offset(spacing)
        }
        return base
    }
    
    /// 紧接在另一控件上方，可指定间距
    @discardableResult public func above(_ view: UIView, _ spacing: CGFloat = 0) -> UIView {
        base.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.top).offset(-spacing)
        }
        return base
    }
    
    /// 向上撑起父控件，即令控件上边至少在父控件上边的下方
    @discardableResult public func inflateUp(_ inset: CGFloat = 0) -> UIView {
        base.snp.makeConstraints {
            $0.top.greaterThanOrEqualToSuperview().offset(inset)
        }
        return base
    }
    
    /// 向上撑起父控件，即令控件下边至少在父控件下边的上方
    @discardableResult public func inflateDown(_ inset: CGFloat = 0) -> UIView {
        base.snp.makeConstraints {
            $0.bottom.lessThanOrEqualToSuperview().offset(-inset)
        }
        return base
    }
    
    /// 向左撑起父控件，即令控件左边至少在父控件左边的右方
    @discardableResult public func inflateLeft(_ inset: CGFloat = 0) -> UIView {
        base.snp.makeConstraints {
            $0.left.greaterThanOrEqualToSuperview().offset(inset)
        }
        return base
    }
    
    /// 向右撑起父控件，即令控件右边至少在父控件右边的左方
    @discardableResult public func inflateRight(_ inset: CGFloat = 0) -> UIView {
        base.snp.makeConstraints {
            $0.right.lessThanOrEqualToSuperview().offset(-inset)
        }
        return base
    }
    
    /// 自动向下排列，即自动寻找父控件中上一个控件，紧贴在其下方，并自动向下撑起父控件
    @discardableResult public func flowDown(_ spacing: CGFloat = 0) -> UIView {
        let lastView = base.superview?.subviews.filter { $0 != base }.last
        if let lastView = lastView {
            below(lastView, spacing)
        } else {
            top()
        }
        inflateDown()
        return base
    }
    
    /// 自动向右排列，即自动寻找父控件中上一个控件，紧贴在其右方，并自动向右撑起父控件
    @discardableResult public func flowRight(_ spacing: CGFloat = 0) -> UIView {
        let lastView = base.superview?.subviews.filter { $0 != base }.last
        if let lastView = lastView {
            after(lastView, spacing)
        } else {
            left()
        }
        inflateRight()
        return base
    }
}
