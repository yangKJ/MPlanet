//
//  CGImageSource+Ext.swift
//  ImageX
//
//  Created by Condy on 2023/1/5.
//

import Foundation
import ImageIO
import Harbeth
#if canImport(MobileCoreServices)
import MobileCoreServices
#endif

extension CGImageSource: ImageXCompatible { }

extension ImageXEngine where CGImageSource == Base {
    
    public func toImage(index: Int) -> C7Image? {
        toCGImage(index: index)?.c7.toC7Image()
    }
    
    public func toCGImage(index: Int) -> CGImage? {
        CGImageSourceCreateImageAtIndex(base, index, nil)
    }
    
    /// Retruns the duration of a frame at a specific index using an image source (an `CGImageSource` instance).
    /// - Parameters:
    ///   - index: Specific index.
    ///   - dictionaryProperty: The image container property key used in ImageIO API. Such as `kCGImagePropertyGIFDictionary`.
    ///   - unclampedDelayTimeProperty: The image unclamped delay time property key used in ImageIO API. Such as `kCGImagePropertyGIFUnclampedDelayTime`
    ///   - delayTimeProperty: The image delay time property key used in ImageIO API. Such as `kCGImagePropertyGIFDelayTime`.
    /// - Returns: A frame duration.
    public func frameDuration(at index: Int,
                              dictionaryProperty: String,
                              unclampedDelayTimeProperty: String,
                              delayTimeProperty: String) -> TimeInterval {
        // Returns the GIF properties at a specific index.
        func properties(at index: Int) -> [String: Double]? {
            guard let properties = CGImageSourceCopyPropertiesAtIndex(base, index, nil) as? [String: AnyObject] else {
                return nil
            }
            return properties[dictionaryProperty] as? [String: Double]
        }
        // Returns a frame duration from a `[String: Double]` dictionary.
        func frameDuration(with properties: [String: Double]) -> Double? {
            guard let unclampedDelayTime = properties[unclampedDelayTimeProperty],
                  let delayTime = properties[delayTimeProperty] else {
                return nil
            }
            return [unclampedDelayTime, delayTime].filter({ $0 >= 0 }).first
        }
        // Most animated run between 15 and 24 Frames per second.
        let defaultFrameRate: Double = 15.0
        
        // Threshold used in `capDuration` for a FrameDuration
        let capDurationThreshold: Double = 0.02 - Double.ulpOfOne
        
        // Return nil, if the properties do not store a FrameDuration or FrameDuration <= 0
        guard let properties = properties(at: index), let duration = frameDuration(with: properties), duration > 0 else {
            return 1.0 / defaultFrameRate
        }
        return duration < capDurationThreshold ? 0.1 : duration
    }
}
