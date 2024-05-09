//
//  AssetType.swift
//  ImageX
//
//  Created by Condy on 2023/2/28.
//

import Foundation
import Harbeth

/// A uniform type identifier UTI.
public enum AssetType: String, Hashable, Sendable {
    /// Unknown format. Either not enough data, or we just don't support this format.
    case unknow = "public.unknow"
    
    case jpeg = "public.jpeg"
    case png = "public.png"
    case gif = "com.compuserve.gif"
    case tiff = "public.tiff"
    
    /// Native decoding support only available on the following platforms: macOS 11, iOS 14, watchOS 7, tvOS 14.
    case webp = "org.webmproject.webp"
    
    /// HEIF (High Efficiency Image Format) by Apple.
    case heic = "public.heic"
    case heif = "public.heif"
    
    // Reference source: https://github.com/SDWebImage/SDWebImage/blob/master/SDWebImage/Private/SDImageIOAnimatedCoderInternal.h
    
    case raw = "public.camera-raw-image"
    
    case svg = "public.svg-image"
    
    case pdf = "com.adobe.pdf"
    
    case bmp = "com.microsoft.bmp"
    
    /// The M4V file format is a video container format developed by Apple and is very similar to the MP4 format.
    /// The primary difference is that M4V files may optionally be protected by DRM copy protection.
    case mp4 = "public.mp4"
    case m4v = "public.m4v"
    case mov = "public.mov"
    
    /// Determines a type of the image based on the given data.
    public init(data: Data?) {
        if let data = data {
            self = AssetType.make(data: data)
        } else {
            self = .unknow
        }
    }
    
    /// Synchronize obtain the current link type.
    /// Tips: this operation will jam the current thread.
    public init(url: URL) {
        let data = try? Data.init(contentsOf: url)
        self = AssetType.init(data: data)
    }
}

extension AssetType {
    
    public static func synchronizeAssetType(with url: URL) throws -> (type: AssetType, data: Data) {
        do {
            let data = try Data.init(contentsOf: url)
            return (AssetType.init(data: data), data)
        } catch {
            throw error
        }
    }
    
    public typealias AssetTypeComplete = (_ type: AssetType) -> Void
    
    /// Asynchronously obtain the current link asset type and Data.
    /// You only need to download the first frame to determine the type.
    /// - Parameters:
    ///   - url: Link url.
    ///   - complete: Result callback.
    public static func asyncAssetType(with url: URL, complete: @escaping AssetTypeComplete) {
        let options = ImageXOptions.init()
        Networking.shared.addDownloadURL(url, options: options, downloadBlock: { result in
            switch result {
            case .failure:
                complete(.unknow)
            case .success(let res):
                if res.downloadStatus == .complete {
                    complete(AssetType(data: res.data))
                }
                switch res.downloadStatus {
                case .complete:
                    complete(AssetType(data: res.data))
                case .downloading:
                    let type = AssetType(data: res.data)
                    if type != .unknow {
                        Networking.shared.removeDownloadURL(with: url)
                        complete(type)
                    }
                }
            }
        })
    }
}

extension AssetType {
    
    public var isVideo: Bool {
        self == .mp4 || self == .m4v || self == .mov
    }
    
    public var isHEIC: Bool {
        self == .heic || self == .heif
    }
}

extension AssetType {
    
    private static func make(data: Data) -> AssetType {
        if data.isEmpty {
            return .unknow
        }
        func _match(_ numbers: [UInt8?], offset: Int = 0) -> Bool {
            guard data.count >= numbers.count else {
                return false
            }
            return zip(numbers.indices, numbers).allSatisfy { index, number in
                guard let number = number, (index + offset) < data.count else {
                    return false
                }
                return data[index + offset] == number
            }
        }
        
        // JPEG magic numbers https://en.wikipedia.org/wiki/JPEG
        if _match([0xFF, 0xD8, 0xFF]) { return .jpeg }
        
        // PNG Magic numbers https://en.wikipedia.org/wiki/Portable_Network_Graphics
        if _match([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]) { return .png }
        
        // GIF magic numbers https://en.wikipedia.org/wiki/GIF
        if _match([0x47, 0x49, 0x46]) { return .gif }
        
        // WebP magic numbers https://en.wikipedia.org/wiki/List_of_file_signatures
        // see https://developers.google.com/speed/webp/docs/riff_container
        if _match([0x52, 0x49, 0x46, 0x46, nil, nil, nil, nil, 0x57, 0x45, 0x42, 0x50]) { return .webp }
        
        // see https://stackoverflow.com/questions/21879981/avfoundation-avplayer-supported-formats-no-vob-or-mpg-containers
        // https://en.wikipedia.org/wiki/List_of_file_signatures
        if _match([0x66, 0x74, 0x79, 0x70, 0x69, 0x73, 0x6F, 0x6D], offset: 4) { return .mp4 }
        
        if _match([0x66, 0x74, 0x79, 0x70, 0x6D, 0x70, 0x34, 0x32], offset: 4) { return .m4v }
        
        // MOV magic numbers https://www.garykessler.net/library/file_sigs.html
        if _match([0x66, 0x74, 0x79, 0x70, 0x71, 0x74, 0x20, 0x20], offset: 4) { return .mov }
        
        var buffer = [UInt8](repeating: 0, count: 1)
        data.copyBytes(to: &buffer, count: 1)
        switch buffer {
        case [0xFF]:
            return .jpeg
        case [0x89]:
            return .png
        case [0x47]:
            return .gif
        case [0x49], [0x4D]:
            return .tiff
        case [0x52] where data.count >= 12:
            if let str = String(data: data[0...11], encoding: .ascii), str.hasPrefix("RIFF"), str.hasSuffix("WEBP") {
                return .webp
            }
        case [0x00] where data.count >= 12:
            if let str = String(data: data[8...11], encoding: .ascii) {
                let HEICBitMaps = Set(["heic", "heis", "heix", "hevc", "hevx"])
                if HEICBitMaps.contains(str) {
                    return .heic
                }
                let HEIFBitMaps = Set(["mif1", "msf1"])
                if HEIFBitMaps.contains(str) {
                    return .heif
                }
            }
        default:
            break
        }
        
        // 特殊格式
        if let type = imageSourceGetType(data: data) {
            return type
        }
        
        // Either not enough data, or we just don't support this format.
        return .unknow
    }
    
    static func imageSourceGetType(data: Data) -> AssetType? {
        let dataOptions = [String(kCGImageSourceShouldCache): kCFBooleanFalse] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, dataOptions),
              let uttype = CGImageSourceGetType(imageSource) else {
            return nil
        }
        for type in [AssetType.raw, AssetType.svg, AssetType.bmp, AssetType.pdf] {
            if UTTypeConformsTo(uttype, (type.rawValue as CFString)) {
                return type
            }
        }
        return nil
    }
}
