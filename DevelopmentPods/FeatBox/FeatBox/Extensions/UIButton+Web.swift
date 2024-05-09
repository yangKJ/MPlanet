//
//  UIButton+Web.swift
//  FeatBox
//
//  Created by Condy on 2023/3/14.
//

import Foundation
import ImageX
import Harbeth
import ProductLib
import SDWebImage

/// 网图or本地图显示，支持image和gif
extension BoxWrapper where Base: UIButton {
    
    public func setImage(with named: String?, for state: UIControl.State, placeholder: UIImage? = nil, filters: [C7FilterProtocol]?) {
        var url: URL?
        if let named = named, named.fy.verifyLink() {
            url = URL(string: named)
        }
        setImage(with: url, for: state, placeholder: placeholder, filters: filters)
    }
    
    public func setImage(with url: URL?, for state: UIControl.State, placeholder: UIImage? = nil, filters: [C7FilterProtocol]?) {
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
        base.kj.setImage(with: url, for: state, options: options)
    }
    
    public func setImage(with named: String?, for state: UIControl.State, placeholder: UIImage? = nil) {
        var url: URL?
        if let named = named, named.fy.verifyLink() {
            url = URL(string: named)
        }
        setImage(with: url, for: state, placeholder: placeholder)
    }
    
    public func setImage(with url: URL?, for state: UIControl.State, placeholder: UIImage? = nil) {
        base.sd_setImage(with: url, for: state, placeholderImage: placeholder)
    }
}
