//
//  FrameStore.swift
//  ImageX
//
//  Created by Condy on 2023/1/5.
//

import Foundation
import ImageIO
import Harbeth

/// Responsible for storing and updating the frames of a single animated image.
final class FrameStore {
    /// Desired number of loops, <= 0 for infinite loop
    private let loopCount: Int
    /// Maximum duration to increment the frame timer with.
    private let maxTimeStep: TimeInterval
    /// Maximum number of frames to load at once.
    /// A high number will result in more memory usage and less CPU load, and vice versa.
    private var bufferFrameCount: Int
    /// Decoder for decoding animated images.
    private let decoder: AnimatedCodering
    /// Parameters configured for the decoder.
    private let coderOptions: ImageCodering.ImageCoderOptions
    
    /// An array of animated frames from a single animated image.
    @Locked var animatedFrames: [FrameImage] = [FrameImage]()
    /// Index of current loop.
    var currentLoop = 0
    /// Total duration of one animation loop.
    var loopDuration: TimeInterval = 0
    /// Duration of each animated image frame.
    var durations: [TimeInterval] = []
    /// Flag indicating if number of loops has been reached.
    var isFinished: Bool = false
    
    /// Dispatch queue used for preloading images.
    private lazy var preloadFrameQueue = DispatchQueue(label: "condy.animator.preload.frame.queue")
    /// Time elapsed since the last frame change. Used to determine when the frame should be updated.
    private var timeSinceLastFrameChange: TimeInterval = 0.0
    
    /// The index of the current animated image frame.
    private var currentFrameIndex = 0 {
        didSet {
            previousFrameIndex = oldValue
        }
    }
    
    /// The index of the previous animated image frame.
    private var previousFrameIndex = 0 {
        didSet {
            preloadFrameQueue.async { self.updatePreloadedFrames() }
        }
    }
    
    /// The total number of frames in the animated image.
    var frameCount: Int {
        return decoder.frameCount
    }
    
    /// The first frame that is not nil of animated image.
    var fristFrame: C7Image? {
        return animatedFrames.compactMap({ $0.image }).first
    }
    
    /// The current image frame to show.
    var currentFrameImage: C7Image? {
        return frame(at: currentFrameIndex)
    }
    
    /// Bitmap memory cost with bytes.
    var cost: Int {
        guard let image = currentFrameImage else {
            return 0
        }
        return Int(image.size.height * image.size.width * 4) * frameCount / 1_000_000
    }
    
    /// Is this image animatable?
    var isAnimatable: Bool {
        return frameCount > 1
    }
    
    /// Creates an animator instance from raw animated image data.
    /// - Parameters:
    ///   - decoder: Decoder for decoding animated images.
    ///   - options: Set the other parameters.
    ///   - prepared: Ready to start playing.
    init(decoder: AnimatedCodering, options: ImageXOptions, prepared: @escaping (FrameStore) -> Void) {
        self.loopCount = options.Animated.loop.count
        self.maxTimeStep = options.Animated.maxTimeStep
        self.bufferFrameCount = options.Animated.bufferCount
        self.decoder = decoder
        self.coderOptions = options.setupDecoderOptions(finished: true)
        self.preloadFrameQueue.async { [weak self] in
            guard let weakSelf = self else { return }
            (weakSelf.loopDuration, weakSelf.durations) = decoder.animatedDuration(maxTimeStep: weakSelf.maxTimeStep)
            weakSelf.bufferFrameCount = weakSelf.durations.count
            let indexs = weakSelf.preloadIndexes(index: 0)
            weakSelf.animatedFrames = decoder.decodeAnimatedImage(options: weakSelf.coderOptions, durations: weakSelf.durations, indexes: indexs)
            weakSelf.setupPreparationed(options: options, prepared: prepared)
        }
    }
    
    private func setupPreparationed(options: ImageXOptions, prepared: @escaping (FrameStore) -> Void) {
        DispatchQueue.main.async {
            if let preparation = options.Animated.preparation {
                let res = GIFResponse(data: self.decoder.data,
                                      animatedFrames: self.animatedFrames,
                                      loopDuration: self.loopDuration,
                                      fristFrame: self.fristFrame,
                                      activeFrame: self.currentFrameImage,
                                      frameCount: self.frameCount,
                                      isAnimating: self.isAnimatable,
                                      cost: self.cost)
                preparation(res)
            }
            prepared(self)
        }
    }
    
    /// Checks whether the frame should be changed and calls a handler with the results.
    ///
    /// - parameter duration: A `CFTimeInterval` value that will be used to determine whether frame should be changed.
    /// - parameter handler: A function that takes a `Bool` and returns nothing. It will be called with the frame change result.
    func shouldChangeFrame(with duration: CFTimeInterval, handler: @escaping (Bool) -> Void) {
        incrementTimeSinceLastFrameChange(with: duration)
        if currentFrameDuration() > timeSinceLastFrameChange {
            DispatchQueue.main.async { handler(false) }
        } else {
            resetTimeSinceLastFrameChange()
            incrementCurrentFrameIndex()
            DispatchQueue.main.async { handler(true) }
        }
    }
}

private extension FrameStore {
    /// Returns the frame at a particular index.
    ///
    /// - parameter index: The index of the frame.
    /// - returns: An optional image at a given frame.
    func frame(at index: Int) -> C7Image? {
        return animatedFrames[safe: index]?.image
    }
    
    /// Returns the duration at a particular index.
    ///
    /// - parameter index: The index of the duration.
    /// - returns: The duration of the given frame.
    func duration(at index: Int) -> TimeInterval {
        return animatedFrames[safe: index]?.duration ?? TimeInterval.infinity
    }
    
    /// The current frame duration
    func currentFrameDuration() -> TimeInterval {
        return duration(at: currentFrameIndex)
    }
    
    /// Updates the frames by preloading new ones and replacing the previous frame with a placeholder.
    func updatePreloadedFrames() {
        if !(bufferFrameCount < frameCount - 1) { return }
        let indexs = preloadIndexes(index: currentFrameIndex)
        self.animatedFrames = decoder.decodeAnimatedImage(options: coderOptions, durations: durations, indexes: indexs)
    }
    
    /// Increments the `timeSinceLastFrameChange` property with a given duration.
    ///
    /// - parameter duration: An `NSTimeInterval` value to increment the `timeSinceLastFrameChange` property with.
    func incrementTimeSinceLastFrameChange(with duration: TimeInterval) {
        timeSinceLastFrameChange += min(maxTimeStep, duration)
    }
    
    /// Ensures that `timeSinceLastFrameChange` remains accurate after each frame change by substracting the `currentFrameDuration`.
    func resetTimeSinceLastFrameChange() {
        timeSinceLastFrameChange -= currentFrameDuration()
    }
    
    /// Increments the `currentFrameIndex` property.
    func incrementCurrentFrameIndex() {
        currentFrameIndex = increment(frameIndex: currentFrameIndex)
        if isLastLoop(loopIndex: currentLoop) && isLastFrame(frameIndex: currentFrameIndex) {
            isFinished = true
        } else if currentFrameIndex == 0 {
            currentLoop = currentLoop + 1
        }
    }
    
    /// Increments a given frame index, taking into account the `frameCount` and looping when necessary.
    ///
    /// - parameter index: The `Int` value to increment.
    /// - parameter byValue: The `Int` value to increment with.
    /// - returns: A new `Int` value.
    func increment(frameIndex: Int, by value: Int = 1) -> Int {
        return (frameIndex + value) % frameCount
    }
    
    /// Indicates if current frame is the last one.
    /// - parameter frameIndex: Index of current frame.
    /// - returns: True if current frame is the last one.
    func isLastFrame(frameIndex: Int) -> Bool {
        return frameIndex == frameCount - 1
    }
    
    /// Indicates if current loop is the last one. Always false for infinite loops.
    /// - parameter loopIndex: Index of current loop.
    /// - returns: True if current loop is the last one.
    func isLastLoop(loopIndex: Int) -> Bool {
        return loopIndex == loopCount - 1
    }
    
    /// Returns the indexes of the frames to preload based on a starting frame index.
    ///
    /// - parameter index: Starting index.
    /// - returns: An array of indexes to preload.
    func preloadIndexes(index: Int) -> [Int] {
        func indexs(min: Int, max: Int) -> [Int] {
            var indexs__ = [Int]()
            for _ in 0..<max/min {
                indexs__ += [Int](0..<min)
            }
            indexs__ += [Int](0..<max%min)
            return indexs__
        }
        let min = min(bufferFrameCount, frameCount)
        let max = max(bufferFrameCount, frameCount)
        let indexs = [Int](index%frameCount..<frameCount) + indexs(min: min, max: max)
        return indexs[0..<bufferFrameCount].map { $0 }
    }
}
