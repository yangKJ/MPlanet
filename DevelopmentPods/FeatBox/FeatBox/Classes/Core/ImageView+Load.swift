//
//  ImageView+Load.swift
//  FeatBox
//
//  Created by Condy on 2023/3/14.
//

import Foundation
import Wintersweet

/// 网图or本地图显示，支持image和gif
extension BoxWrapper where Base: ImageView {
    
    /// 网图or本地图显示，支持image和gif
    /// - Parameters:
    ///   - named: 图像名称
    ///   - module: 模块名，组件化项目必须要传`named`资源所在模块名才能正确读取本地数据
    ///   - placeholder: 占位图，默认不使用占位信息
    ///   - filters: 是否需要注入滤镜
    public func setImage(with named: String, module: String, placeholder: Wintersweet.Placeholder = .none, filters: [C7FilterProtocol]? = nil) {
        base.contentMode = .scaleAspectFit
        let options = Wintersweet.AnimatedOptions.init(loop: .forever,
                                                       placeholder: placeholder,
                                                       contentMode: .scaleAspectFit,
                                                       bufferCount: 20,
                                                       cacheOption: .disk,
                                                       cacheCrypto: .sha1,
                                                       cacheDataZip: .gzip,
                                                       moduleName: module)
        base.mt.displayImage(named: named, filters: filters ?? [], options: options)
    }
    
    /// 网图显示，支持image和gif
    /// - Parameters:
    ///   - url: 网图链接
    ///   - placeholder: 占位图，默认不使用占位信息
    ///   - filters: 是否需要注入滤镜
    public func setImage(with url: URL?, placeholder: Wintersweet.Placeholder = .none, filters: [C7FilterProtocol]? = nil) {
        guard let url = url else { return }
        base.contentMode = .scaleAspectFit
        let options = Wintersweet.AnimatedOptions.init(loop: .forever,
                                                       placeholder: placeholder,
                                                       contentMode: .scaleAspectFit,
                                                       bufferCount: 20,
                                                       cacheOption: .disk,
                                                       cacheCrypto: .sha1,
                                                       cacheDataZip: .gzip)
        base.mt.displayImage(url: url, filters: filters ?? [], options: options)
    }
}
