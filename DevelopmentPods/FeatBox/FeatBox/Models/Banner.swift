//
//  Banner.swift
//  Featbox
//
//  Created by Condy on 2023/4/28.
//

import Foundation
import SmartCodable

/// 广告模型
public struct Banner: SmartCodableX, Routerable {
    public var id: Int?
    
    public var title: String?
    public var desc: String?
    public var order: Int?
    public var imagePath: URL?
    
    public var height: CGFloat?
    
    public var fixedHeight: Bool = false // 是否固定高度，固定高度则取`height`字段
    
    public var gotoType: String?
    public var gotoObject: String?
    
    public static func mappingForKey() -> [SmartKeyTransformer]? {
        return [
            CodingKeys.fixedHeight <--- ["fixed_height"],
        ]
    }
    
    public init() { }
}

extension Banner: Equatable {
    public static func == (lhs: Banner, rhs: Banner) -> Bool {
        return lhs.id == rhs.id && lhs.imagePath == rhs.imagePath && lhs.order == rhs.order
    }
}
