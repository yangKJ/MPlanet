//
//  AnimatedCodering.swift
//  ImageX
//
//  Created by Condy on 2023/7/15.
//

import Foundation
import ImageIO
import Harbeth
#if canImport(MobileCoreServices)
import MobileCoreServices
#endif

/// Set up encode or decode to animated images.
public protocol AnimatedCodering: ImageCodering {
    
    /// The image container property key used in ImageIO API.
    var dictionaryProperty: String { get }
    
    /// The image unclamped delay time property key used in ImageIO API.
    var unclampedDelayTimeProperty: String { get }
    
    /// The image delay time property key used in ImageIO API.
    var delayTimeProperty: String { get }
    
    /// The total duration of animation and each animated image frame duration.
    /// - Parameter maxTimeStep: Maximum duration to increment the frame timer with.
    /// - Returns: The total duration and each durations.
    func animatedDuration(maxTimeStep: TimeInterval) -> (total: TimeInterval, durations: [TimeInterval])
    
    /// Decode the data to animated image.
    /// - Parameters:
    ///   - options: A dictionary containing any decoding options.
    ///   - indexes: An array of indexes to preload.
    /// - Returns: Returns a range frame array frome data.
    func decodeAnimatedCGImage(options: ImageCoderOptions, indexes: [Int]) -> [CGImage?]
}

extension AnimatedCodering {
    
    /// The total duration of animation and each animated image frame duration.
    /// - Parameter maxTimeStep: Maximum duration to increment the frame timer with.
    /// - Returns: The total duration and each durations.
    public func animatedDuration(maxTimeStep: TimeInterval) -> (total: TimeInterval, durations: [TimeInterval]) {
        guard let imageSource = imageSource else {
            return (0.0, [])
        }
        let eachDurations = (0..<frameCount).map {
            let time = imageSource.img.frameDuration(at: $0,
                                                     dictionaryProperty: dictionaryProperty,
                                                     unclampedDelayTimeProperty: unclampedDelayTimeProperty,
                                                     delayTimeProperty: delayTimeProperty)
            return min(time, maxTimeStep)
        }
        let total = eachDurations.reduce(0.0, { $0 + $1 })
        return (total, eachDurations)
    }
    
    public func decodeAnimatedCGImage(options: ImageCoderOptions, indexes: [Int]) -> [CGImage?] {
        guard canDecode(), isAnimatedImages() else {
            return []
        }
        return indexes.map { index in
            decodedCGImage(options: options, index: index)
        }
    }
}

extension AnimatedCodering {
    
    /// Decode the data to animated image.
    /// - Parameters:
    ///   - options: A dictionary containing any decoding options.
    ///   - durations: Duration of each animated image frame.
    ///   - range: Those frames are currently needed.
    /// - Returns: Returns a range frame array frome data.
    func decodeAnimatedImage(options: ImageCoderOptions, durations: [TimeInterval], indexes: [Int]) -> [FrameImage] {
        let filters = options[CoderOptions.decoder.filtersKey] as? [C7FilterProtocol] ?? []
        let resize = options[CoderOptions.decoder.thumbnailPixelSizeKey] as? CGSize ?? .zero
        let resizingMode = options[CoderOptions.decoder.resizingModeKey] as? ImageX.ResizingMode ?? .original
        let cgImages = decodeAnimatedCGImage(options: options, indexes: indexes)
        return Array(zip(cgImages, indexes)).map {
            let dest = HarbethIO(element: $0, filters: filters)
            var image = try? dest.output()?.c7.toC7Image()
            if let image_ = image {
                image = resizingMode.resizeImage(image_, size: resize)
            }
            return FrameImage(cgImage: $0, image: image, duration: durations[$1])
        }
    }
}
