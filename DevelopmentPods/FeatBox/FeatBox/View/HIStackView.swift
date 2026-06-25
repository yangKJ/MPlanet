//
//  HIStackView.swift
//  FeatBox
//
//  Created by Condy on 2024/5/20.
//

import Foundation
import ProductLib
import SnapKit

open class HIStackView: BaseView {
    
    public enum CIStackViewAlignment {
        case head
        case center
        case tail
    }
    
    public var alignment: CIStackViewAlignment = .center {
        didSet {
            self.set(views: self.views)
        }
    }
    
    public var asix: NSLayoutConstraint.Axis = .vertical {
        didSet {
            if self.views.count > 0 {
                self.set(views: self.views)
            }
        }
    }
    
    public var margin: UIEdgeInsets = UIEdgeInsets.zero
    
    private var views = [UIView]()
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setContentHuggingPriority(UILayoutPriority(rawValue: 1), for: .horizontal)
        self.setContentHuggingPriority(UILayoutPriority(rawValue: 1), for: .vertical)
        self.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1), for: .horizontal)
        self.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1), for: .vertical)
    }
    
    public override func awakeFromNib() {
        self.setContentHuggingPriority(UILayoutPriority(rawValue: 1), for: .horizontal)
        self.setContentHuggingPriority(UILayoutPriority(rawValue: 1), for: .vertical)
        self.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1), for: .horizontal)
        self.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1), for: .vertical)
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 1, height: 1)
    }
    
    public func set(views: [UIView]) {
        self.views.forEach {
            self.removeConstraintsExceptWithAndHeight(view: $0)
            $0.removeFromSuperview()
        }
        self.views.removeAll()
        self.append(views: views)
    }
    
    public func append(view: UIView) {
        self.append(views: [view])
    }
    
    public func append(views: [UIView]) {
        self.insert(views: views, startIndex: self.views.count)
    }
    
    public func insert(view: UIView, at index: Int) {
        self.insert(views: [view], startIndex: index)
    }
    
    public func insert(views: [UIView], startIndex: Int) {
        let views = views.filter { (view) -> Bool in
            return !self.views.contains(view)
        }
        if (views.count == 0) {
            return
        }
        var currentIndex = max(0, min(startIndex, self.views.count))
        if let previousView = self.views[safe: currentIndex-1] {
            self.removeConstraintsExceptWithAndHeight(view: previousView)
            self.setConstrsetConstraintHead(view: previousView)
            self.setAlignConstraint(view: previousView)
        }
        views.enumerated().forEach { (offset, element) in
            if currentIndex > 0, let aboveView = self.views[safe: currentIndex-1] {
                self.insertSubview(element, aboveSubview: aboveView)
            } else {
                self.addSubview(element)
            }
            self.views.insert(element, at: currentIndex)
            self.setConstrsetConstraintHead(view: element)
            self.setAlignConstraint(view: element)
            currentIndex += 1
        }
        if let nextView = self.views[safe: currentIndex] {
            self.setConstrsetConstraintHead(view: nextView)
        }
        if currentIndex == self.views.count {
            self.setConstraintLastViewLastTail()
        }
    }
    
    @discardableResult public func delete(at index: Int) -> UIView? {
        guard let view = self.views[safe: index] else {
            return nil
        }
        self.removeConstraintsExceptWithAndHeight(view: view)
        view.removeFromSuperview()
        self.views.remove(at: index)
        if let nextView = self.views[safe: index] {
            self.setConstrsetConstraintHead(view: nextView)
        } else if self.views[safe: index-1] != nil {
            self.setConstraintLastViewLastTail()
        }
        return view
    }
    
    private func setConstrsetConstraintHead(view: UIView) {
        guard let index = self.views.firstIndex(of: view) else {
            return
        }
        view.snp.makeConstraints { (make) in
            if index == 0 {
                let headEdge = Float(self.margin.fy.stackHead(of: self.asix) + (view.stackEdge?.fy.stackHead(of: self.asix) ?? 0))
                make.stackHead(of: self.asix).equalTo(headEdge)
            } else {
                let previous = views[index - 1]
                let previoutTail = previous.stackEdge?.fy.stackTail(of: self.asix) ?? 0
                let currentHead = view.stackEdge?.fy.stackHead(of: self.asix) ?? 0
                let space = previoutTail + currentHead
                make.stackHead(of: self.asix).equalTo(previous.snp.stackTail(of: self.asix)).offset(space)
            }
        }
    }
    
    private func setConstraintLastViewLastTail() {
        guard let view = self.views.last else {
            return
        }
        view.snp.makeConstraints { (make) in
            let tailEdge = Float(self.margin.fy.stackTail(of: self.asix) + (view.stackEdge?.fy.stackTail(of: self.asix) ?? 0))
            make.stackTail(of: self.asix).equalTo(-tailEdge).priority(view.manageStackFrameByUser ? 2.0 : ConstraintPriority.required)
        }
    }
    
    private func setAlignConstraint(view: UIView) {
        view.snp.makeConstraints { (make) in
            let headEdge = Float(self.margin.fy.stackAlignmentHead(of: self.asix) + (view.stackEdge?.fy.stackAlignmentHead(of: self.asix) ?? 0))
            let tailEdge = Float(self.margin.fy.stackAlignmentTail(of: self.asix) + (view.stackEdge?.fy.stackAlignmentTail(of: self.asix) ?? 0))
            let head = make.stackAlignmentHead(of: self.asix)
            let tail = make.stackAlignmentTail(of: self.asix)
            let center = make.stackAlignmentCenter(of: self.asix)
            switch alignment {
            case .head:
                head.equalTo(headEdge)
                if view.manageStackFrameByUser {
                    tail.lessThanOrEqualTo(-tailEdge).priority(2.0)
                } else {
                    tail.lessThanOrEqualTo(-tailEdge).priority(ConstraintPriority.required)
                }
            case .center:
                if view.manageStackFrameByUser {
                    center.equalToSuperview()
                    head.greaterThanOrEqualTo(headEdge).priority(2.0)
                    tail.lessThanOrEqualTo(-tailEdge).priority(2.0)
                } else {
                    head.equalTo(headEdge).priority(ConstraintPriority.required)
                    tail.equalTo(-tailEdge).priority(ConstraintPriority.required)
                }
            case .tail:
                tail.equalTo(-tailEdge)
                if view.manageStackFrameByUser {
                    head.greaterThanOrEqualTo(headEdge).priority(2.0)
                } else {
                    head.equalTo(headEdge).priority(ConstraintPriority.required)
                }
            }
        }
    }
    
    private func removeConstraintsExceptWithAndHeight(view: UIView) {
        if let superview = view.superview {
            // !(第一个参数是view的宽高 或者 第一个不是view) || (第一个参数的非宽高属性与view有关)
            let constraints = superview.constraints.filter {
                !(($0.firstItem as? NSObject == view && ($0.firstAttribute == .height || $0.firstAttribute == .width)) || $0.firstItem as? NSObject != view) || ($0.secondItem as? NSObject == view && $0.firstAttribute != .height && $0.firstAttribute != .width)
            }
            view.superview?.removeConstraints(constraints)
        }
    }
}
