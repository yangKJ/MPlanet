//
//  ConstraintMaker+Ext.swift
//  FeatBox
//
//  Created by Condy on 2024/5/20.
//

import Foundation
import SnapKit

extension ConstraintMaker {
    
    public func stackHead(of asix: NSLayoutConstraint.Axis) -> ConstraintMakerExtendable {
        switch asix {
        case .horizontal:
            return self.left
        case .vertical:
            return self.top
        }
    }
    
    public func stackTail(of asix: NSLayoutConstraint.Axis) -> ConstraintMakerExtendable {
        switch asix {
        case .horizontal:
            return self.right
        case .vertical:
            return self.bottom
        }
    }
    
    public func stackAlignmentCenter(of asix: NSLayoutConstraint.Axis) -> ConstraintMakerExtendable {
        switch asix {
        case .horizontal:
            return self.centerY
        case .vertical:
            return self.centerX
        }
    }
    
    public func stackAlignmentHead(of asix: NSLayoutConstraint.Axis) -> ConstraintMakerExtendable {
        switch asix {
        case .horizontal:
            return self.top
        case .vertical:
            return self.left
        }
    }
    
    public func stackAlignmentTail(of asix: NSLayoutConstraint.Axis) -> ConstraintMakerExtendable {
        switch asix {
        case .horizontal:
            return self.bottom
        case .vertical:
            return self.right
        }
    }
}


extension ConstraintAttributesDSL {
    
    public func stackHead(of asix: NSLayoutConstraint.Axis) -> ConstraintItem {
        switch asix {
        case .horizontal:
            return self.left
        case .vertical:
            return self.top
        }
    }
    
    public func stackTail(of asix: NSLayoutConstraint.Axis) -> ConstraintItem {
        switch asix {
        case .horizontal:
            return self.right
        case .vertical:
            return self.bottom
        }
    }
    
    public func stackHeadMargin(of asix: NSLayoutConstraint.Axis) -> ConstraintItem {
        switch asix {
        case .horizontal:
            return self.leftMargin
        case .vertical:
            return self.topMargin
        }
    }
    
    public func stackTailMargin(of asix: NSLayoutConstraint.Axis) -> ConstraintItem {
        switch asix {
        case .horizontal:
            return self.rightMargin
        case .vertical:
            return self.bottomMargin
        }
    }
}
