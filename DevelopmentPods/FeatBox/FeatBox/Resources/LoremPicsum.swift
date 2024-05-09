//
//  LoremPicsum.swift
//  FeatBox
//
//  Created by Condy on 2023/7/7.
//

import Foundation

//  图片资源首页：https://picsum.photos
//  所有图片列表：https://picsum.photos/images
//  PS：此处`size`的单位是像素，如果想要适配手机像素，`size`的宽高记得乘以`UIScreen.main.scale`

public enum LoremPicsum {
    
    static let baseURL = "https://picsum.photos"
    
    public enum Suffix: String {
        case jpg
        case webp
    }
    
    /// 随机图片URL
    /// - Parameters:
    ///   - size: 图片尺寸，单位是px，如果想要适配手机像素，`size`的宽高记得乘以`UIScreen.main.scale`
    ///   - id: 图片ID，具体去 https://picsum.photos/images 查询
    ///   - randomId: 随机ID，当请求多个相同大小的图像时，添加该参数以防止获取缓存的同一图片
    ///   - suffix: 图片后缀
    public static func photoURL(size: CGSize, id: Int? = nil, randomId: Int? = nil, suffix: Suffix? = nil) -> URL {
        var urlStr = Self.baseURL
        if let id = id {
            urlStr += "/id/\(id)"
        }
        urlStr += "/\(Int(size.width))/\(Int(size.height))"
        if let randomId = randomId {
            if urlStr.contains("?") {
                urlStr += "&random=\(randomId)"
            } else {
                urlStr += "?random=\(randomId)"
            }
        }
        if let suffix = suffix {
            urlStr += ".\(suffix.rawValue)"
        }
        return URL(string: urlStr)!
    }
    
    /// 随机图片列表
    /// - Parameters:
    ///   - page: 页码
    ///   - limit: 每一页的图片数（默认30张一页）
    public static func photoListURL(page: Int, limit: Int? = nil) -> URL {
        var urlStr = Self.baseURL + "/v2/list" + "?page=\(page)"
        if let limit = limit {
            urlStr += "&limit=\(limit)"
        }
        return URL(string: urlStr)!
    }
    
    /// 图片信息
    /// - Parameters:
    ///   - id: 图片ID（具体去 https://picsum.photos/images 查询）
    public static func photoInfoURL(id: Int) -> URL {
        let urlStr = Self.baseURL + "/id/\(id)/info"
        return URL(string: urlStr)!
    }
}

extension LoremPicsum {
    /// 随机图片URL，自带随机ID，范围：`1...10000`
    public static func photoURLWithRandomId(size: CGSize) -> URL {
        return photoURL(size: size, randomId: Int.random(in: 1...10000))
    }
    
    /// 随机图片URL
    /// - Parameters:
    ///   - size: 图片尺寸，单位是px，如果想要适配手机像素，`size`的宽高记得乘以`UIScreen.main.scale`
    ///   - randomId: 随机ID，当请求多个相同大小的图像时，添加该参数以防止获取缓存的同一图片
    public static func photoURL(size: CGSize, randomId: Int) -> URL {
        return photoURL(size: size, randomId: randomId)
    }
}
