//
//  FrameStore.swift
//  Wintersweet
//
//  Created by Condy on 2023/1/5.
//

import Foundation
import ImageIO
import Harbeth

/// Responsible for storing and updating the frames of a single GIF.
final class FrameStore {
    /// Desired number of loops, <= 0 for infinite loop
    private let loopCount: Int
    /// Harbeth filters apply to GIF frame.
    private let filters: [Harbeth.C7FilterProtocol]
    /// Maximum duration to increment the frame timer with.
    private let maxTimeStep = 1.0
    /// The target size for all frames.
    private let size: CGSize
    /// The content mode to use when resizing.
    private let contentMode: Wintersweet.ContentMode
    /// Maximum number of frames to load at once.
    /// A high number will result in more memory usage and less CPU load, and vice versa.
    private let bufferFrameCount: Int
    /// A reference to the original image source.
    private let imageSource: CGImageSource
    
    /// An array of animated frames from a single GIF image.
    @Locked var animatedFrames = [FrameImage]()
    /// Index of current loop.
    var currentLoop = 0
    /// Total duration of one animation loop.
    var loopDuration: TimeInterval = 0
    /// Flag indicating if number of loops has been reached.
    var isFinished: Bool = false
    /// The total number of frames in the GIF.
    var frameCount = 0
    
    /// Dispatch queue used for preloading images.
    private lazy var preloadFrameQueue = DispatchQueue(label: "condy.gif.animator.preloadFrameQueue")
    /// Time elapsed since the last frame change. Used to determine when the frame should be updated.
    private var timeSinceLastFrameChange: TimeInterval = 0.0
    
    /// The index of the current GIF frame.
    private var currentFrameIndex = 0 {
        didSet {
            previousFrameIndex = oldValue
        }
    }
    
    /// The index of the previous GIF frame.
    private var previousFrameIndex = 0 {
        didSet {
            preloadFrameQueue.async { self.updatePreloadedFrames() }
        }
    }
    
    /// The first frame that is not nil of GIF.
    var fristFrame: C7Image? {
        return animatedFrames.compactMap({ $0.image }).first
    }
    
    /// The current image frame to show.
    var currentFrameImage: C7Image? {
        return frame(at: currentFrameIndex)
    }
    
    /// Is this image animatable?
    var isAnimatable: Bool {
        return imageSource.mt.isAnimatedGIF
    }
    
    /// Bitmap memory cost with bytes.
    var cost: Int {
        guard let image = currentFrameImage else {
            return 0
        }
        return Int(image.size.height * image.size.width * 4) * frameCount / 1_000_000
    }
    
    /// Creates an animator instance from raw GIF image data and an `Animatable` delegate.
    /// - Parameters:
    ///   - data: The raw GIF image data.
    ///   - size: View frame used for resizing the size.
    ///   - framePreloadCount: Number of frame to buffer.
    ///   - contentMode: The content mode to use when resizing.
    ///   - loopCount: Desired number of loops, <= 0 for infinite loop.
    init(data: Data, filters: [C7FilterProtocol], size: CGSize, framePreloadCount: Int, contentMode: Wintersweet.ContentMode, loopCount: Int) {
        let options = [String(kCGImageSourceShouldCache): kCFBooleanFalse] as CFDictionary
        self.imageSource = CGImageSourceCreateWithData(data as CFData, options) ?? CGImageSourceCreateIncremental(options)
        self.size = size
        self.filters = filters
        self.bufferFrameCount = framePreloadCount
        self.loopCount = loopCount
        self.contentMode = contentMode
    }
    
    /// Loads the frames from an image source, resizes them, then caches them in `animatedFrames`.
    func prepareFrames(_ complete: @escaping () -> Void) {
        frameCount = Int(CGImageSourceGetCount(imageSource))
        animatedFrames.reserveCapacity(frameCount)
        preloadFrameQueue.async {
            self.setupAnimatedFrames()
            DispatchQueue.main.async { complete() }
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
        let frame = animatedFrames[previousFrameIndex]
        let placeholderFrame = FrameImage(image: nil, duration: frame.duration)
        animatedFrames[previousFrameIndex] = placeholderFrame
        for index in preloadIndexes(withStartingIndex: currentFrameIndex) {
            loadFrameAtIndex(index)
        }
    }
    
    func loadFrameAtIndex(_ index: Int) {
        let frame = animatedFrames[index]
        if !frame.isPlaceholder { return }
        let image = loadFrame(at: index)
        let loadedFrame = FrameImage(image: image, duration: frame.duration)
        animatedFrames[index] = loadedFrame
    }
    
    /// Optionally loads a single frame from an image source,  add filter and resizes it if required.
    ///
    /// - parameter index: The index of the frame to load.
    /// - returns: An optional `C7Image` instance.
    func loadFrame(at index: Int) -> C7Image? {
        let cgImage = CGImageSourceCreateImageAtIndex(imageSource, index, nil)
        let image: C7Image?
        if let cgImage = try? BoxxIO(element: cgImage, filters: filters).output() {
            image = cgImage.mt.toC7Image()
        } else {
            image = cgImage?.mt.toC7Image()
        }
        return contentMode.resizeImage(image, size: size)
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
    func preloadIndexes(withStartingIndex index: Int) -> [Int] {
        let nextIndex = increment(frameIndex: index)
        let lastIndex = increment(frameIndex: index, by: bufferFrameCount)
        if lastIndex >= nextIndex {
            return [Int](nextIndex...lastIndex)
        } else {
            return [Int](nextIndex..<frameCount) + [Int](0...lastIndex)
        }
    }
    
    func setupAnimatedFrames() {
        animatedFrames.removeAll()
        var duration: TimeInterval = 0
        (0..<frameCount).forEach { index in
            let frameDuration = imageSource.mt.frameDuration(at: index)
            duration += min(frameDuration, maxTimeStep)
            let frame = FrameImage(image: nil, duration: frameDuration)
            animatedFrames.append(frame)
            if index > bufferFrameCount { return }
            loadFrameAtIndex(index)
        }
        self.loopDuration = duration
    }
}
