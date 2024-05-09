//
//  HasAnimatable.swift
//  ImageX
//
//  Created by Condy on 2023/1/5.
//

import Foundation
import QuartzCore
import Harbeth

public protocol HasAnimatable: NSObjectProtocol {
    /// Responsible for managing the animation frames.
    //var animator: Animator? { get set }
    
    /// View frame used for resizing the frames.
    var frame: CGRect { get set }
    
    #if os(macOS)
    /// Notifies the instance that it needs display.
    var layer: CALayer? { get }
    
    /// Updates the layout of the receiving view and its subviewsbased on the current views and constraints.
    func layoutSubtreeIfNeeded()
    #else
    /// Notifies the instance that it needs display.
    var layer: CALayer { get }
    
    #if canImport(UIKit)
    /// Options to specify how a view adjusts its content when its size changes.
    /// A flag used to determine how a view lays out its content when its bounds change.
    var contentMode: UIView.ContentMode { get set }
    #endif
    
    /// Lays out subviews. Used xib and then get the subviews frame.
    func layoutSubviews()
    
    /// Lays out the subviews immediately, if layout updates are pending.
    func layoutIfNeeded()
    
    /// Nvalidates the current layout of the receiver and triggers a layout update during the next update cycle.
    func setNeedsLayout()
    #endif
}

fileprivate var ImageXAnimatorContext: UInt8 = 0

extension HasAnimatable {
    
    var hasAnimator: Animator? {
        return synchronizedAnimator {
            guard let weakself = self as? AsAnimatable else {
                return nil
            }
            return objc_getAssociatedObject(weakself, &ImageXAnimatorContext) as? Animator
        }
    }
    
    /// Responsible for managing the animation frames.
    weak var animator: Animator? {
        get {
            return synchronizedAnimator {
                guard let weakself = self as? AsAnimatable else {
                    return nil
                }
                if let animator = objc_getAssociatedObject(weakself, &ImageXAnimatorContext) as? Animator {
                    return animator
                } else {
                    let animator = Animator(withDelegate: weakself)
                    objc_setAssociatedObject(weakself, &ImageXAnimatorContext, animator, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                    return animator
                }
            }
        }
        set {
            synchronizedAnimator {
                objc_setAssociatedObject(self, &ImageXAnimatorContext, newValue as Animator?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    func synchronizedAnimator<T>( _ action: () -> T) -> T {
        objc_sync_enter(self)
        let result = action()
        objc_sync_exit(self)
        return result
    }
}
