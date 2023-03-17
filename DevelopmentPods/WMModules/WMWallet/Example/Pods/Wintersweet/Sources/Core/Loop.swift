//
//  Loop.swift
//  Wintersweet
//
//  Created by Condy on 2023/1/12.
//

import Foundation

public enum Loop {
    /// Unlimited loop playback.
    case forever
    /// Play once.
    case never
    /// The specified  `count` number of plays.
    case count(_ count: Int)
    /// Displayed the first frame.
    case fristFrame
    /// Displayed the last frame.
    case lastFrame
}

extension Wintersweet.Loop {
    /// Desired number of loops.
    var count: Int {
        switch self {
        case .forever:
            return 0
        case .never:
            return 1
        case .count(let count):
            assert(count > 0) // disable: this empty_count
            return count
        case .fristFrame, .lastFrame:
            return 0
        }
    }
}
