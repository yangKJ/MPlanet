//
//  GIFResponse.swift
//  ImageX
//
//  Created by Condy on 2023/7/3.
//

import Foundation
import Harbeth

public struct GIFResponse {
    
    /// The animated images data.
    public let data: Data
    
    /// The animated images frame diagram.
    public let animatedFrames: [FrameImage]
    
    /// Total duration of one animation loop.
    public let loopDuration: TimeInterval
    
    /// The first frame that is not nil of animated images.
    public let fristFrame: C7Image?
    
    /// Returns the active frame if available.
    public let activeFrame: C7Image?
    
    /// Total frame count of the animated images.
    public let frameCount: Int
    
    /// Introspect whether the instance is animating.
    public let isAnimating: Bool
    
    /// Bitmap memory cost with bytes.
    public let cost: Int
}
