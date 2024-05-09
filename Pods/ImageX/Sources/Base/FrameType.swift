//
//  FrameType.swift
//  ImageX
//
//  Created by Condy on 2023/7/15.
//

import Foundation

/// Animated image sources become static display of appoint frames.
public enum FrameType: Equatable {
    /// Displayed the animated images.
    case animated
    /// Displayed the first frame.
    case frist
    /// Displayed the last frame.
    case last
    /// Displayed appoint the frame, beyond the last frame.
    case appoint(Int)
    
    func index(_ frameCount: Int) -> Int {
        switch self {
        case .frist:
            return 0
        case .last:
            return frameCount
        case .appoint(let int):
            return min(frameCount, int)
        default:
            return 0
        }
    }
}
