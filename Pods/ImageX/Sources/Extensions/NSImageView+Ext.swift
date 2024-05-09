//
//  NSImageView+Ext.swift
//  ImageX
//
//  Created by Condy on 2023/1/5.
//

import Foundation
import Harbeth

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

public typealias ImageView = NSImageView

extension NSImageView: AsAnimatable, ImageContainer, ImageXCompatible { }

extension ImageXEngine where Base: NSImageView {
    
    /// Display image or gif and add the filters.
    /// - Parameters:
    ///   - named: Picture or gif name.
    ///   - options: Represents creating options used in ImageX.
    public func setImage(with named: String?, options: ImageXOptions = .default) {
        Driver.setImage(named: named, to: base, options: options, other: nil)
    }
    
    /// Display image or gif and add the filters.
    /// - Parameters:
    ///   - data: Picture data.
    ///   - options: Represents creating options used in ImageX.
    /// - Returns: A uniform type identifier UTI.
    @discardableResult public func setImage(with data: Data?, options: ImageXOptions = .default) -> AssetType {
        Driver.setImage(data: data, to: base, options: options, other: nil)
    }
    
    /// Display network image or gif and add the filters.
    /// - Parameters:
    ///   - url: Link url.
    ///   - options: Represents creating options used in ImageX.
    /// - Returns: Current network URLSessionDataTask.
    @discardableResult public func setImage(with url: URL?, options: ImageXOptions = .default) -> ImageX.Task? {
        Driver.setImage(url: url, to: base, options: options, other: nil)
    }
}

#endif
