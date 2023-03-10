//
//  FrameImage.swift
//  Wintersweet
//
//  Created by Condy on 2023/1/5.
//

import Foundation
import Harbeth

/// Represents a single frame in a GIF.
struct FrameImage {
    
    /// The image to display for this frame. Its value is nil when the frame is removed from the buffer.
    let image: Harbeth.C7Image?
    
    /// The duration that this frame should remain active.
    let duration: TimeInterval
}

extension FrameImage {
    /// Whether this frame instance contains an image or not.
    var isPlaceholder: Bool {
        image == .none
    }
}
