//
//  FrameImage.swift
//  ImageX
//
//  Created by Condy on 2023/1/5.
//

import Foundation
import Harbeth

/// Represents a single frame in a GIF.
public struct FrameImage {
    
    /// Original resources cgImage, No filter data has been added.
    public let cgImage: CGImage?
    
    /// The image to display for this frame. Its value is nil when the frame is removed from the buffer.
    public let image: Harbeth.C7Image?
    
    /// The duration that this frame should remain active.
    public let duration: TimeInterval
}

extension FrameImage {
    /// Whether this frame instance contains an image or not.
    var isPlaceholder: Bool {
        image == .none
    }
}
