//
//  ImageXOptions+Animated.swift
//  ImageX
//
//  Created by Condy on 2023/7/12.
//

import Foundation

extension ImageXOptions {
    
    public struct Animated {
        
        /// Desired number of loops. Default is ``forever``.
        public var loop: ImageX.Loop = .forever
        
        /// Animated image sources become still image display of appoint frames.
        /// After this property is not ``.animated``, it will become a still image.
        public var frameType: ImageX.FrameType = .animated
        
        /// The number of frames to buffer. Default is 50.
        /// A high number will result in more memory usage and less CPU load, and vice versa.
        public var bufferCount: Int = 50
        
        /// Maximum duration to increment the frame timer with.
        public var maxTimeStep = 1.0
        
        public init() { }
        
        internal var preparation: ((_ res: ImageX.GIFResponse) -> Void)?
        /// Ready to play time callback.
        /// - Parameter block: Prepare to play the callback.
        public mutating func setPreparationBlock(block: @escaping ((_ res: ImageX.GIFResponse) -> Void)) {
            self.preparation = block
        }
        
        internal var animated: ((_ loopDuration: TimeInterval) -> Void)?
        /// Animated images playback completed.
        /// - Parameter block: Complete the callback.
        public mutating func setAnimatedBlock(block: @escaping ((_ loopDuration: TimeInterval) -> Void)) {
            self.animated = block
        }
    }
}
