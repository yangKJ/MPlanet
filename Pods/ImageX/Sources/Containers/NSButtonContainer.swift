//
//  NSButtonContainer.swift
//  ImageX
//
//  Created by Condy on 2023/6/30.
//

import Foundation
import Harbeth

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

public protocol NSButtonContainer {
    
    /// The image that appears on the button when it’s in an off state, or nil if there is no such image.
    var image: Harbeth.C7Image? { get set }
    
    /// An alternate image that appears on the button when the button is in an on state, or nil if there is no such image.
    /// Note that some button types do not display an alternate image.
    var alternateImage: Harbeth.C7Image? { get set }
}

#endif
