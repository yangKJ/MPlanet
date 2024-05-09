//
//  ImageJPEGCoder.swift
//  ImageX
//
//  Created by Condy on 2023/7/15.
//

import Foundation
import Harbeth

public struct ImageJPEGCoder: ImageCodering {
    
    public var data: Data
    
    public var imageSource: CGImageSource?
    
    public var frameCount: Int = 0
    
    public var format: AssetType {
        .jpeg
    }
    
    public init(data: Data) {
        self.data = data
    }
    
    public func canDecoderBrokenData() -> Bool {
        return true
    }
    
    public func decodedCGImage(options: ImageCoderOptions, index: Int) -> CGImage? {
        guard canDecode(), let imageSource = self.imageSource else {
            return nil
        }
        return imageSource.img.toCGImage(index: index)
    }
    
    public static func encodeImage(_ image: Harbeth.C7Image, options: ImageCoderOptions) -> Data? {
        let compressionQuality = options[CoderOptions.encoder.compressionQualityKey] as? CGFloat ?? 1.0
        #if os(macOS)
        guard let cgImage = image.cgImage else {
            return nil
        }
        let rep = NSBitmapImageRep(cgImage: cgImage)
        return rep.representation(using: .jpeg, properties: [.compressionFactor: compressionQuality])
        #else
        return image.jpegData(compressionQuality: compressionQuality)
        #endif
    }
}
