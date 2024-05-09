//
//  AnimatedGIFsCoder.swift
//  ImageX
//
//  Created by Condy on 2023/7/15.
//

import Foundation
import Harbeth

public struct AnimatedGIFsCoder: AnimatedCodering {
    
    public var data: Data
    
    public var imageSource: CGImageSource?
    
    public var frameCount: Int = 0
    
    public var format: AssetType {
        .gif
    }
    
    public var unclampedDelayTimeProperty: String {
        String(kCGImagePropertyGIFUnclampedDelayTime)
    }
    
    public var delayTimeProperty: String {
        String(kCGImagePropertyGIFDelayTime)
    }
    
    public var dictionaryProperty: String {
        String(kCGImagePropertyGIFDictionary)
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
