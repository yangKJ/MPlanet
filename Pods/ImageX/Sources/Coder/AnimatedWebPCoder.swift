//
//  AnimatedWebPCoder.swift
//  ImageX
//
//  Created by Condy on 2023/7/15.
//

import Foundation
import Harbeth

public struct AnimatedWebPCoder: AnimatedCodering {
    
    public var data: Data
    
    public var imageSource: CGImageSource?
    
    public var frameCount: Int = 0
    
    public var format: AssetType {
        .webp
    }
    
    public var unclampedDelayTimeProperty: String {
        if #available(iOS 14.0, tvOS 14, macOS 11, watchOS 7, *) {
            return String(kCGImagePropertyWebPUnclampedDelayTime)
        } else {
            return "UnclampedDelayTime"
        }
    }
    
    public var delayTimeProperty: String {
        if #available(iOS 14.0, tvOS 14, macOS 11, watchOS 7, *) {
            return String(kCGImagePropertyWebPDelayTime)
        } else {
            return "DelayTime"
        }
    }
    
    public var dictionaryProperty: String {
        if #available(iOS 14.0, tvOS 14, macOS 11, watchOS 7, *) {
            return String(kCGImagePropertyWebPDictionary)
        } else {
            return "{WebP}"
        }
    }
    
    public init(data: Data) {
        self.data = data
    }
    
    public func decodedCGImage(options: ImageCoderOptions, index: Int) -> CGImage? {
        guard canDecode(), let imageSource = self.imageSource else {
            return nil
        }
        return imageSource.img.toCGImage(index: index)
    }
    
    public static func encodeImage(_ image: Harbeth.C7Image, options: ImageCoderOptions) -> Data? {
        return nil
    }
}
