//
//  NSLayoutConstraint+Ext.swift
//  ProductLib
//
//  Created by Condy on 2025/10/16.
//

import Foundation

extension BoxWrapper where Base: NSLayoutConstraint {
    
    /// Update the multiplier constraint.
    /// - Parameter multiplier: New multiplier constraint value.
    /// - Returns: A new constraint.
    public func setUpdateMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        guard let firstItem = base.firstItem else {
            return base
        }
        NSLayoutConstraint.deactivate([base])
        let newConstraint = NSLayoutConstraint(item: firstItem,
                                               attribute: base.firstAttribute,
                                               relatedBy: base.relation,
                                               toItem: base.secondItem,
                                               attribute: base.secondAttribute,
                                               multiplier: multiplier,
                                               constant: base.constant)
        newConstraint.priority = base.priority
        newConstraint.shouldBeArchived = base.shouldBeArchived
        newConstraint.identifier = base.identifier
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}
