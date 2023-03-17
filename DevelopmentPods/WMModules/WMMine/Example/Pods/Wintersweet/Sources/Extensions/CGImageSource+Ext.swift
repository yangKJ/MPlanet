//
//  CGImageSource+Ext.swift
//  Wintersweet
//
//  Created by Condy on 2023/1/5.
//

import Foundation
import ImageIO
import Harbeth
#if canImport(MobileCoreServices)
import MobileCoreServices
#endif

extension CGImageSource: C7Compatible { }

extension Queen where CGImageSource == Base {
    
    /// Returns whether the image source contains an animated GIF.
    public var isAnimatedGIF: Bool {
        let isTypeGIF = UTTypeConformsTo(CGImageSourceGetType(base) ?? "" as CFString, kUTTypeGIF)
        let imageCount = CGImageSourceGetCount(base)
        return isTypeGIF != false && imageCount > 1
    }
    
    /// Retruns the duration of a frame at a specific index using an image source (an `CGImageSource` instance).
    /// - Parameter index: Specific index.
    /// - Returns: A frame duration.
    public func frameDuration(at index: Int) -> TimeInterval {
        guard isAnimatedGIF else { return 0.0 }
        // Returns the GIF properties at a specific index.
        func properties(at index: Int) -> [String: Double]? {
            guard let properties = CGImageSourceCopyPropertiesAtIndex(base, index, nil) as? [String: AnyObject] else { return nil }
            return properties[String(kCGImagePropertyGIFDictionary)] as? [String: Double]
        }
        // Returns a frame duration from a `[String: Double]` dictionary.
        func frameDuration(with properties: [String: Double]) -> Double? {
            guard let unclampedDelayTime = properties[String(kCGImagePropertyGIFUnclampedDelayTime)],
                  let delayTime = properties[String(kCGImagePropertyGIFDelayTime)] else {
                return nil
            }
            return [unclampedDelayTime, delayTime].filter({ $0 >= 0 }).first
        }
        // Most GIFs run between 15 and 24 Frames per second.
        let defaultFrameRate: Double = 15.0
        
        // Threshold used in `capDuration` for a FrameDuration
        let capDurationThreshold: Double = 0.02 - Double.ulpOfOne
        
        // Return nil, if the properties do not store a FrameDuration or FrameDuration <= 0
        guard let properties = properties(at: index), let duration = frameDuration(with: properties), duration > 0 else {
            return 1 / defaultFrameRate
        }
        return duration < capDurationThreshold ? 0.1 : duration
    }
}
