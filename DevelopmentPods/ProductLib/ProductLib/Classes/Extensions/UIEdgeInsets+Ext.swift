//
//  UIEdgeInsets+Ext.swift
//  FeatBox
//
//  Created by Condy on 2024/5/20.
//

import Foundation

extension BoxWrapper where Base == UIEdgeInsets {
    
    public func stackHead(of asix: NSLayoutConstraint.Axis) -> CGFloat {
        switch asix {
        case .horizontal:
            return self.base.left
        case .vertical:
            return self.base.top
        }
    }
    
    public func stackTail(of asix: NSLayoutConstraint.Axis) -> CGFloat {
        switch asix {
        case .horizontal:
            return self.base.right
        case .vertical:
            return self.base.bottom
        }
    }
    
    public func stackAlignmentHead(of asix: NSLayoutConstraint.Axis) -> CGFloat {
        switch asix {
        case .horizontal:
            return self.base.top
        case .vertical:
            return self.base.left
        }
    }
    
    public func stackAlignmentTail(of asix: NSLayoutConstraint.Axis) -> CGFloat {
        switch asix {
        case .horizontal:
            return self.base.bottom
        case .vertical:
            return self.base.right
        }
    }
}
