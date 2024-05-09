//
//  UIImageView+Ext.swift
//  ImageX
//
//  Created by Condy on 2023/7/3.
//

import Foundation
import Harbeth

#if canImport(UIKit) && !os(watchOS)
import UIKit

public typealias ImageView = UIImageView

extension UIImageView: AsAnimatable, UIImageViewContainer, ImageXCompatible { }

extension ImageXEngine where Base: UIImageView {
    
    /// Display image or gif and add the filters.
    /// - Parameters:
    ///   - named: Picture or gif name.
    ///   - options: Represents creating options used in ImageX.
    public func setImage(with named: String?, options: ImageXOptions = .default) {
        let other = Others(key: Others.UIImageViewKey.image.rawValue, value: nil)
        Driver.setImage(named: named, to: base, options: options, other: other)
    }
    
    /// Display image or gif and add the filters.
    /// - Parameters:
    ///   - data: Picture data.
    ///   - options: Represents creating options used in ImageX.
    /// - Returns: A uniform type identifier UTI.
    @discardableResult public func setImage(with data: Data?, options: ImageXOptions = .default) -> AssetType {
        let other = Others(key: Others.UIImageViewKey.image.rawValue, value: nil)
        return Driver.setImage(data: data, to: base, options: options, other: other)
    }
    
    /// Display network image or gif and add the filters.
    /// - Parameters:
    ///   - url: Link url.
    ///   - options: Represents creating options used in ImageX.
    /// - Returns: Current network URLSessionDataTask.
    ///
    /// - Note:
    /// This is the easiest way to use ImagX to boost the image setting process from a source.
    /// You can set an image from a certain URL to an image view like this:
    ///
    /// ```
    /// // Set image from a url.
    /// let url = URL(string: "https://example.com/image.png")
    /// imageView.img.setImage(with: url)
    ///
    /// // Or set other parameters play gif or downloading image.
    /// var options = AnimatedOptions(moduleName: "Component Name")
    /// options.placeholder = .image(R.image("AppIcon")!)
    /// options.resizingMode = .scaleAspectBottomRight
    /// options.Animated.loop = .count(3)
    /// options.Animated.bufferCount = 20
    /// options.Cache.cacheOption = .disk
    /// options.Cache.cacheCrypto = .md5
    /// options.Cache.cacheDataZip = .gzip
    /// options.Network.retry = .max3s
    /// options.Network.timeoutInterval = 30
    ///
    /// let url = URL(string: "https://example.com/image.png")!
    /// imageView.img.setImage(with: url, options: options)
    /// ```
    @discardableResult public func setImage(with url: URL?, options: ImageXOptions = .default) -> ImageX.Task? {
        let other = Others(key: Others.UIImageViewKey.image.rawValue, value: nil)
        return Driver.setImage(url: url, to: base, options: options, other: other)
    }
    
    /// Display image or gif and add the filters.
    /// - Parameters:
    ///   - named: Picture or gif name.
    ///   - options: Represents creating options used in ImageX.
    public func setHighlightedImage(with named: String?, options: ImageXOptions = .default) {
        let other = Others(key: Others.UIImageViewKey.highlightedImage.rawValue, value: nil)
        Driver.setImage(named: named, to: base, options: options, other: other)
    }
    
    /// Display image or gif and add the filters.
    /// - Parameters:
    ///   - data: Picture data.
    ///   - options: Represents creating options used in ImageX.
    /// - Returns: A uniform type identifier UTI.
    @discardableResult public func setHighlightedImage(with data: Data?, options: ImageXOptions = .default) -> AssetType {
        let other = Others(key: Others.UIImageViewKey.highlightedImage.rawValue, value: nil)
        return Driver.setImage(data: data, to: base, options: options, other: other)
    }
    
    /// Display network image or gif and add the filters.
    /// - Parameters:
    ///   - url: Link url.
    ///   - options: Represents creating options used in ImageX.
    /// - Returns: Current network URLSessionDataTask.
    @discardableResult public func setHighlightedImage(with url: URL?, options: ImageXOptions = .default) -> ImageX.Task? {
        let other = Others(key: Others.UIImageViewKey.highlightedImage.rawValue, value: nil)
        return Driver.setImage(url: url, to: base, options: options, other: other)
    }
}

#endif
