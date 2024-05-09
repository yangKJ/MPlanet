//
//  BaseView.swift
//  FeatBox
//
//  Created by Condy on 2023/10/11.
//

import Foundation
import SnapKit

open class BaseView: UIView {
    
    public convenience init(width: CGFloat) {
        self.init(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        snp.makeConstraints { (make) in
            make.width.equalTo(width)
        }
    }
    
    public convenience init(height: CGFloat) {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: height))
        snp.makeConstraints { (make) in
            make.height.equalTo(height)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupInit()
    }
    
    private func setupInit() {
        self.layer.masksToBounds = true
    }
    
    public func getCenter() -> CGPoint {
        return convert(center, from: superview)
    }
}

extension UIView {
    
    open func setPriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
        self.setContentHuggingPriority(priority, for: axis)
        self.setContentCompressionResistancePriority(priority, for: axis)
    }
}
