//
//  UIImageView+Web.swift
//  FeatBox
//
//  Created by Condy on 2023/3/14.
//

import Foundation
import ProductLib
import Harbeth
import ImageX
import SDWebImage

/// 网图or本地图显示，支持image和gif
extension BoxWrapper where Base: UIImageView {
    
    public func setImage(with named: String?, placeholder: UIImage? = nil, filters: [C7FilterProtocol]?) {
        var url: URL?
        if let named = named, named.fy.verifyLink() {
            url = URL(string: named)
        }
        setImage(with: url, placeholder: placeholder, filters: filters)
    }
    
    /// 网图or本地图显示，支持image和gif
    /// - Parameters:
    ///   - url: 图像链接
    ///   - placeholder: 占位图，默认不使用占位信息
    ///   - filters: 是否需要注入滤镜
    public func setImage(with url: URL?, placeholder: UIImage? = nil, filters: [C7FilterProtocol]?) {
        var options = ImageXOptions.init()
        if let placeholder = placeholder {
            options.placeholder = .image(placeholder)
        }
        options.resizingMode = .original
        options.Animated.loop = .forever
        options.Animated.bufferCount = 20
        options.Cache.cacheOption = .disk
        options.Cache.cacheCrypto = .sha1
        options.Cache.cacheDataZip = .gzip
        options.filters = filters ?? []
        base.kj.setImage(with: url, options: options)
    }
    
    public func setImage(with named: String?, placeholder: UIImage? = nil) {
        var url: URL?
        if let named = named, named.fy.verifyLink() {
            url = URL(string: named)
        }
        setImage(with: url, placeholder: placeholder)
    }
    
    public func setImage(with url: URL?, placeholder: UIImage? = nil) {
        base.sd_setImage(with: url, placeholderImage: placeholder)
//        base.image = placeholder
//        SDWebImageDownloader.shared.downloadImage(with: url, options: .lowPriority, progress: nil, completed: { image, data, _, _ in
//            guard let image = image, let filters = filters else {
//                return
//            }
//            let dest = HarbethIO(element: image, filters: filters)
//            dest.transmitOutput(success: { outImage in
//                DispatchQueue.main.async {
//                    base.image = outImage
//                }
//            })
//        })
    }
}
