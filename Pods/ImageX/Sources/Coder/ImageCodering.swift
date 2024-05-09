//
//  ImageCodering.swift
//  ImageX
//
//  Created by Condy on 2023/7/15.
//

import Foundation
import ObjectiveC
import ImageIO
import Harbeth
#if canImport(MobileCoreServices)
@_exported import MobileCoreServices
#endif

/// Set up encode or decode to still image.
public protocol ImageCodering {
    
    typealias ImageCoderOptions = [String: Any]
    
    /// The supported image format.
    var format: AssetType { get }
    
    /// A uniform type identifier UTI.
    var imageUTType: String { get }
    
    /// The dictionary may be used to request additional creation options.
    var dataOptions: CFDictionary { get }
    
    /// The image data to be decoded.
    var data: Data { get set }
    
    /// The original image source.
    var imageSource: CGImageSource? { get set }
    
    /// Total number animated frames.
    var frameCount: Int { get set }
    
    /// Is it a animated images resource?
    func isAnimatedImages() -> Bool
    
    /// Returns YES if this coder can decode some data. Otherwise, the data should be passed to another coder.
    func canDecode() -> Bool
    
    /// Can it be progressive displayed incrementally.
    func progressive() -> Bool
    
    /// Real time decoder of incomplete data.
    func canDecoderBrokenData() -> Bool
    
    /// Decode the data to CGImage.
    /// - Parameters:
    ///   - options: A dictionary containing any decoding options.
    ///   - index: The index of the frame to load.
    /// - Returns: The decoded CGImage from data.
    func decodedCGImage(options: ImageCoderOptions, index: Int) -> CGImage?
    
    // MARK: - encoder
    
    /// Encode the image to data.
    /// - Parameters:
    ///   - image: The image to be encoded.
    ///   - options: A dictionary containing any encoding options.
    /// - Returns: The encoded image data
    static func encodeImage(_ image: C7Image, options: ImageCoderOptions) -> Data?
}

extension ImageCodering {
    
    public var dataOptions: CFDictionary {
        [String(kCGImageSourceShouldCache): kCFBooleanFalse] as CFDictionary
    }
    
    public var imageUTType: String {
        format.rawValue
    }
    
    public func canDecode() -> Bool {
        //AssetType(data: data) == format
        return true
    }
    
    public func isAnimatedImages() -> Bool {
        return frameCount > 1
    }
    
    public func progressive() -> Bool {
        return false
    }
    
    public func canDecoderBrokenData() -> Bool {
        return false
    }
}

extension ImageCodering {
    
    /// Set up the original image source and total number animated frames.
    mutating func setupImageSource(data: Data) {
        if data.isEmpty == true {
            self.frameCount = 0
            self.imageSource = nil
            return
        }
        if let imageSource = CGImageSourceCreateWithData(data as CFData, dataOptions) {
            self.frameCount = Int(CGImageSourceGetCount(imageSource))
            self.imageSource = imageSource
            return
        }
        // Try again without UTType hint, the call site from user may provide the wrong UTType.
        if let imageSource = CGImageSourceCreateWithData(data as CFData, nil) {
            self.frameCount = Int(CGImageSourceGetCount(imageSource))
            self.imageSource = imageSource
            return
        }
    }
    
    /// Decode the data to image.
    /// - Parameters:
    ///   - options: A dictionary containing any decoding options.
    ///   - onNext: The decoded image from data call back.
    func decodedImage(options: ImageCoderOptions, onNext: @escaping (C7Image?) -> Void) {
        guard canDecode() else {
            return
        }
        let complete = options[CoderOptions.decoder.completeDataKey] as? Bool ?? false
        if !complete && !canDecoderBrokenData() {
            return
        }
        let frameType = options[CoderOptions.decoder.frameTypeKey] as? FrameType ?? .animated
        var cgImage: CGImage? = nil
        if let cgImg = decodedCGImage(options: options, index: frameType.index(frameCount)) {
            cgImage = cgImg
        } else if let cgImg = Harbeth.C7Image.init(data: data)?.cgImage {
            cgImage = cgImg
        }
        let filters = options[CoderOptions.decoder.filtersKey] as? [C7FilterProtocol] ?? []
        var dest = HarbethIO(element: cgImage, filters: filters)
        dest.transmitOutputRealTimeCommit = true
        dest.transmitOutput(success: {
            guard var image = $0?.c7.toC7Image() else {
                onNext(nil)
                return
            }
            if let resize = options[CoderOptions.decoder.thumbnailPixelSizeKey] as? CGSize,
               let resizingMode = options[CoderOptions.decoder.resizingModeKey] as? ImageX.ResizingMode {
                image = resizingMode.resizeImage(image, size: resize)
            }
            onNext(image)
        })
    }
}
