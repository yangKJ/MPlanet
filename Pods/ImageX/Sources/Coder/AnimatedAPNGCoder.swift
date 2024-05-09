//
//  AnimatedAPNGCoder.swift
//  ImageX
//
//  Created by Condy on 2023/7/15.
//

import Foundation
import Harbeth

public struct AnimatedAPNGCoder: AnimatedCodering {
    
    public var data: Data
    
    public var imageSource: CGImageSource?
    
    public var frameCount: Int = 0
    
    public var format: AssetType {
        .png
    }
    
    public var unclampedDelayTimeProperty: String {
        String(kCGImagePropertyAPNGUnclampedDelayTime)
    }
    
    public var delayTimeProperty: String {
        String(kCGImagePropertyAPNGDelayTime)
    }
    
    public var dictionaryProperty: String {
        String(kCGImagePropertyPNGDictionary)
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
        #if os(macOS)
        guard let cgImage = image.cgImage else {
            return nil
        }
        let rep = NSBitmapImageRep(cgImage: cgImage)
        return rep.representation(using: .png, properties: [:])
        #else
        return image.pngData()
        #endif
    }
}
