//
//  UIImageView+Web.swift
//  FeatBox
//
//  Created by Condy on 2023/3/14.
//

import Foundation
import ProductLib
//import Harbeth
//import ImageX
import SDWebImage

//extension BoxWrapper where Base: UIImageView {
//    
//    public func setImage(with named: String?, placeholder: UIImage? = nil, filters: [C7FilterProtocol]?) {
//        guard let named = named else {
//            base.image = placeholder
//            return
//        }
//        let options = setOptions(placeholder: placeholder, filters: filters)
//        base.kj.setImage(with: named, options: options)
//    }
//    
//    /// 网图or本地图显示，支持image和gif
//    /// - Parameters:
//    ///   - url: 图像链接
//    ///   - placeholder: 占位图，默认不使用占位信息
//    ///   - filters: 是否需要注入滤镜
//    public func setImage(with url: URL?, placeholder: UIImage? = nil, filters: [C7FilterProtocol]?) {
//        guard let url = url, url.absoluteString.count > 0 else {
//            base.image = placeholder
//            return
//        }
//        let options = setOptions(placeholder: placeholder, filters: filters)
//        base.kj.setImage(with: url, options: options)
//    }
//    
//    private func setOptions(placeholder: UIImage?, filters: [C7FilterProtocol]?) -> ImageXOptions {
//        var options = ImageXOptions.init()
//        if let placeholder = placeholder {
//            options.placeholder = .image(placeholder)
//        }
//        options.resizingMode = .original
//        options.Animated.loop = .forever
//        options.Animated.bufferCount = 20
//        options.Cache.cacheOption = .disk
//        options.Cache.cacheCrypto = .sha1
//        options.Cache.cacheDataZip = .gzip
//        options.filters = filters ?? []
//        return options
//    }
//}

// MARK: - SDWebImage

extension BoxWrapper where Base: UIImageView {
    
    public func setImage(with named: String?, placeholder: UIImage? = nil) {
        guard let named = named else {
            base.image = placeholder
            return
        }
        if named.fy.verifyLink() {
            setImage(with: URL(string: named), placeholder: placeholder)
        } else if let image = Res.image(named) {
            base.image = image
        } else {
            base.image = placeholder
        }
    }
    
    public func setImage(with url: URL?, placeholder: UIImage? = nil) {
        guard let url = url, url.absoluteString.count > 0 else {
            base.sd_cancelCurrentImageLoad()
            base.image = placeholder
            return
        }
        let options: SDWebImageOptions = [
            SDWebImageOptions.progressiveLoad,
            SDWebImageOptions.lowPriority,
            SDWebImageOptions.continueInBackground,
        ]
        base.sd_setImage(with: url, placeholderImage: placeholder, options: options)
    }
    
    private func image(_ named: String, moduleName: String) -> UIImage? {
        if let image = UIImage.init(named: named) {
            return image
        }
        let bundle = Res.readFrameworkBundle(with: moduleName)
        if let image = UIImage(named: named, in: bundle, compatibleWith: nil) {
            return image
        }
        return nil
    }
}
