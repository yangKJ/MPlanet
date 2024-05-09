//
//  CoderOptions.swift
//  ImageX
//
//  Created by Condy on 2023/7/15.
//

import Foundation

public struct CoderOptions {
    public struct decoder { }
    public struct encoder { }
}

// MARK: - Still image or animated images decoder option

extension CoderOptions.decoder {
    /// A CGSize value indicating whether or not to generate the thumbnail images.
    public static let thumbnailPixelSizeKey = "condy.ImageX.thumbnail.pixel.size.key"
    
    /// Mainly for the image filling content to change the size.
    /// Specify that is not`.original` requires`thumbnailPixelSizeKey` corresponding treatment is not `.zero`.
    /// See: https://github.com/yangKJ/Harbeth/blob/master/Sources/Basic/Setup/ResizingMode.swift
    public static let resizingModeKey = "condy.ImageX.resizing.mode.key"
    
    /// Set up the filters that need to be injected with display image.
    public static let filtersKey = "condy.ImageX.filters.key"
    
    /// Is it a complete data?
    public static let completeDataKey =  "condy.ImageX.complete.data.key"
}

// MARK: - Animated image decoder option

extension CoderOptions.decoder {
    /// Animated image sources become still image display of appoint frames.
    /// See: https://github.com/yangKJ/ImageX/blob/master/Sources/Base/FrameType.swift
    public static let frameTypeKey = "condy.ImageX.animated.frame.type.key"
    
    /// The number of frames to buffer. A high number will result in more memory usage and less CPU load, and vice versa.
    public static let bufferCountKey = "condy.ImageX.animated.buffer.count.key"
    
    /// Maximum duration to increment the frame timer with.
    public static let maxTimeStepKey = "condy.ImageX.animated.max.time.step.key"
}

// MARK: - Still image or animated images encoder option

extension CoderOptions.encoder {
    /// The compression quality when converting image to JPEG data.
    public static let compressionQualityKey = "condy.ImageX.compression.quality.key"
}

// MARK: - Animated image encoder option

extension CoderOptions.encoder {
    
}
