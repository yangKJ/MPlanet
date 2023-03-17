//
//  ImageContainer.swift
//  Wintersweet
//
//  Created by Condy on 2023/1/5.
//

import Foundation
import Harbeth

/// A single-property protocol that animatable classes can optionally conform to.
public protocol ImageContainer {
    /// Used for displaying the animation frames.
    var image: Harbeth.C7Image? { get set }
}

extension AsAnimatable where Self: ImageContainer {
    /// Returns the intrinsic content size based on the size of the image.
    public var intrinsicContentSize: CGSize {
        return image?.size ?? CGSize.zero
    }
}
