//
//  AnimatedHEICCoder.swift
//  ImageX
//
//  Created by Condy on 2023/7/15.
//

import Foundation
import Harbeth

public struct AnimatedHEICCoder: AnimatedCodering {
    
    public var data: Data
    
    public var imageSource: CGImageSource?
    
    public var frameCount: Int = 0
    
    public var format: AssetType {
        .heic
    }
    
    public var unclampedDelayTimeProperty: String {
        if #available(iOS 13, tvOS 13, macOS 10.15, watchOS 6, *) {
            return String(kCGImagePropertyHEICSUnclampedDelayTime)
        } else {
            return "UnclampedDelayTime"
        }
    }
    
    public var delayTimeProperty: String {
        if #available(iOS 13, tvOS 13, macOS 10.15, watchOS 6, *) {
            return String(kCGImagePropertyHEICSDelayTime)
        } else {
            return "DelayTime"
        }
    }
    
    public var dictionaryProperty: String {
        if #available(iOS 13, tvOS 13, macOS 10.15, watchOS 6, *) {
            return String(kCGImagePropertyHEICSDictionary)
        } else {
            return "{HEICS}"
        }
    }
    
    private let type: AssetType
    
    public init(data: Data) {
        self.init(data: data, format: AssetType(data: data))
    }
    
    public init(data: Data, format: AssetType) {
        self.data = data
        self.type = format
    }
    
    public func canDecode() -> Bool {
        self.type.isHEIC
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
