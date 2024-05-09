//
//  WKInterfaceImageContainer.swift
//  ImageX
//
//  Created by Condy on 2023/7/3.
//

import Foundation
import Harbeth
import ObjectiveC

#if canImport(WatchKit)
import WatchKit

public protocol WKInterfaceImageContainer {
    
    /// Used for displaying the animation frames.
    var image: Harbeth.C7Image? { get set }
    
    func setImage(_ image: Harbeth.C7Image?)
}

fileprivate var WKInterfaceImageContainerCacheImageContext: UInt8 = 0

extension WKInterfaceImageContainer {
    
    public var image: Harbeth.C7Image? {
        get {
            return synchronizedCacheImage {
                return objc_getAssociatedObject(self, &WKInterfaceImageContainerCacheImageContext) as? Harbeth.C7Image
            }
        }
        set {
            synchronizedCacheImage {
                objc_setAssociatedObject(self, &WKInterfaceImageContainerCacheImageContext, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    func synchronizedCacheImage<T>( _ action: () -> T) -> T {
        objc_sync_enter(self)
        let result = action()
        objc_sync_exit(self)
        return result
    }
}

#endif
