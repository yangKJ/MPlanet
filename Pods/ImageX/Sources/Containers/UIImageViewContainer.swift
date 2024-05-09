//
//  UIImageViewContainer.swift
//  ImageX
//
//  Created by Condy on 2023/7/3.
//

import Foundation
import ObjectiveC
import Harbeth

#if canImport(UIKit) && !os(watchOS)
import UIKit

public protocol UIImageViewContainer {
    
    /// Used for displaying the animation frames.
    var image: Harbeth.C7Image? { get set }
    
    var highlightedImage: Harbeth.C7Image? { get set }
    
//    /// The array must contain UIImages. Setting hides the single image. default is nil
//    var animationImages: [Harbeth.C7Image]? { get set }
//
//    /// for one cycle of images. default is number of images * 1/30th of a second (i.e. 30 fps)
//    var animationDuration: TimeInterval { get set }
//
//    /// 0 means infinite (default is 0)
//    var animationRepeatCount: Int { get set }
//
//    var isAnimating: Bool { get }
}

//extension UIImageViewContainer {
//    
//    public var animationImages: [Harbeth.C7Image]? {
//        get {
//            switch self {
//            case var ani as AsAnimatable:
//                return ani.animator?.frameStore?.animatedFrames.compactMap({ $0.image })
//            default:
//                return nil
//        }
//        set {
//            animationImages = newValue
//        }
//    }
//
//    public var animationRepeatCount: Int {
//        get {
//            switch self {
//            case var ani as AsAnimatable:
//                return ani.animator?.options?.loop.count ?? 0
//            default:
//                return 0
//            }
//        }
//    }
//
//    public var isAnimating: Bool {
//        !(animationImages?.isEmpty ?? true)
//    }
//}

#endif
