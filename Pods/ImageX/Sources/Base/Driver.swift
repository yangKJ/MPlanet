//
//  Driver.swift
//  ImageX
//
//  Created by Condy on 2023/6/29.
//

import Foundation
import Harbeth
import CacheX

struct Driver {
    
    static func setImage(named: String?, to view: AsAnimatable, options: ImageXOptions, other: Others?) {
        guard let named = named, !named.isEmpty else {
            view.hasAnimator?.prepareForReuse()
            options.setPlaceholder(to: view, other: other)
            return
        }
        let options = options.setPlaceholder(to: view, other: other)
        if R.verifyLink(named), let url = URL(string: named) {
            Driver.setImage(url: url, to: view, options: options, other: other)
        } else if let data = R.gifData(named, forResource: options.moduleName) {
            Driver.setImage(data: data, to: view, options: options, other: other)
        } else if let image = R.image(named, forResource: options.moduleName) {
            view.hasAnimator?.prepareForReuse()
            let options = options.setViewContentMode(to: view)
            let reimage = options.resizingMode.resizeImage(image, size: options.thumbnailPixelSize)
            let dest = HarbethIO(element: reimage, filters: options.filters)
            dest.transmitOutput(success: { outImage in
                options.removeViewPlaceholder(form: view, other: other)
                view.setContentImage(outImage, other: other)
            })
        }
    }
    
    @discardableResult static func setImage(
        data: Data?,
        to view: AsAnimatable,
        finished: Bool = true,
        options: ImageXOptions,
        other: Others?
    ) -> AssetType {
        view.hasAnimator?.prepareForReuse()
        let options = options.setViewContentMode(to: view).setPlaceholder(to: view, other: other)
        guard let data = data else {
            return .unknow
        }
        let decoder = options.fetchDecoder(data: data)
        if options.Animated.frameType == .animated, let decoder = decoder as? AnimatedCodering, decoder.isAnimatedImages() {
            view.setStartPlay(decoder: decoder, options: options, other: other, prepared: {
                options.removeViewPlaceholder(form: view, other: other)
            })
        } else {
            let imageCoderOptions = options.setupDecoderOptions(finished: finished)
            decoder?.decodedImage(options: imageCoderOptions, onNext: { image in
                options.removeViewPlaceholder(form: view, other: other)
                view.setContentImage(image, other: other)
            })
        }
        return decoder?.format ?? AssetType.unknow
    }
    
    @discardableResult static func setImage(
        url: URL?,
        to view: AsAnimatable,
        options: ImageXOptions,
        other: Others?
    ) -> ImageX.Task? {
        view.hasAnimator?.prepareForReuse()
        guard let url = url else {
            options.setPlaceholder(to: view, other: other)
            return nil
        }
        let options = options.setPlaceholder(to: view, other: other)
        let key = options.Cache.cacheCrypto.encryptedString(with: url.absoluteString)
        if var data = Cached.shared.storage.read(key: key, options: options.Cache.cacheOption) {
            data = options.Cache.cacheDataZip.decompress(data: data)
            DispatchQueue.main.async {
                options.Network.progressBlock?(1.0)
                Driver.setImage(data: data, to: view, options: options, other: other)
            }
            return nil
        }
        let task = Networking.shared.addDownloadURL(url, options: options, downloadBlock: { result in
            switch result {
            case .success(let res):
                switch res.downloadStatus {
                case .downloading:
                    DispatchQueue.main.async {
                        Driver.setImage(data: res.data, to: view, finished: false, options: options, other: other)
                    }
                case .complete:
                    DispatchQueue.main.async {
                        Driver.setImage(data: res.data, to: view, options: options, other: other)
                    }
                    let zipData = options.Cache.cacheDataZip.compressed(data: res.data)
                    Cached.shared.storage.write(key: key, value: zipData, options: options.Cache.cacheOption)
                }
            case .failure(let error):
                options.setPlaceholder(to: view, other: other)
                options.Network.failed?(error)
            }
        })
        task.priority = options.Network.downloadPriority
        return ImageX.Task(key: key, url: url, task: task)
    }
    
    /// Get the real frame of the view.
    @discardableResult static func realViewFrame(to view: AsAnimatable) -> CGRect {
        guard view.frame == .zero else {
            return view.frame
        }
        #if !os(macOS)
        // Xib layout to get the size of the subviews.
        if view.frame.size == .zero {
            view.layoutSubviews()
        }
        // Automatic layout to get the size of the subviews.
        if view.frame.size == .zero {
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
        #else
        if view.frame.size == .zero {
            view.layoutSubtreeIfNeeded()
        }
        #endif
        return view.frame
    }
}
