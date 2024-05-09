//
//  Data+Ext.swift
//  ImageX
//
//  Created by Condy on 2023/7/12.
//

import Foundation
import Harbeth

extension Data: ImageXCompatible { }

extension ImageXEngine where Base == Data {
    
    /// Return whether the image source is a dynamic resource.
    public var isAnimated: Bool {
        let options = [String(kCGImageSourceShouldCache): kCFBooleanFalse] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithData(base as CFData, options) else {
            return false
        }
        return CGImageSourceGetCount(imageSource) > 1
    }
    
    /// Determines image size of the image based on the given data.
    /// - Parameter data: Data.
    /// - Returns: Image size.
    public func imageSize() -> CGSize {
        ImageParser.getImageSize(with: base)
    }
    
    public var isGIFs: Bool {
        let length = 3
        var values = [UInt8](repeating: 0, count: length)
        if base.count >= length {
            base.copyBytes(to: &values, count: length)
            //G, I, F
            if Int(values[0]) == 0x47 && Int(values[1]) == 0x49 && Int(values[2]) == 0x46 {
                return true
            }
        }
        return false
    }
}
