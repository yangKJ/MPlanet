//
//  UIButtonContainer.swift
//  ImageX
//
//  Created by Condy on 2023/6/29.
//

import Foundation
import ObjectiveC
import Harbeth

#if canImport(UIKit) && !os(watchOS)
import UIKit

public protocol UIButtonContainer {
    
    func setImage(_ image: UIImage?, for state: UIControl.State)
    
    func setBackgroundImage(_ image: UIImage?, for state: UIControl.State)
}

fileprivate var UIButtonContainerCacheImagesContext: UInt8 = 0

extension UIButtonContainer {
    
    typealias Key = UIControl.State.RawValue
    typealias CacheImagesMap = [Key: (image: UIImage?, backgroundImage: UIImage?)]
    
    var cacheImages: CacheImagesMap {
        get {
            return synchronizedCacheImages {
                if let map = objc_getAssociatedObject(self, &UIButtonContainerCacheImagesContext) as? CacheImagesMap {
                    return map
                } else {
                    let map = CacheImagesMap()
                    objc_setAssociatedObject(self, &UIButtonContainerCacheImagesContext, map, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                    return map
                }
            }
        }
        set {
            synchronizedCacheImages {
                objc_setAssociatedObject(self, &UIButtonContainerCacheImagesContext, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    func synchronizedCacheImages<T>( _ action: () -> T) -> T {
        objc_sync_enter(self)
        let result = action()
        objc_sync_exit(self)
        return result
    }
}

extension AsAnimatable where Self: UIButtonContainer {
    
    public func image(for state: UIControl.State) -> UIImage? {
        self.cacheImages[state.rawValue]?.image
    }
    
    public func backgroundImage(for state: UIControl.State) -> UIImage? {
        self.cacheImages[state.rawValue]?.backgroundImage
    }
}

#endif
