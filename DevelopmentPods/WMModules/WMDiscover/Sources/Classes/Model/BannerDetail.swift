//
//  BannerDetail.swift
//  WMDiscover
//
//  Created by Condy on 2023/5/29.
//

import Foundation
import SmartCodable
import FeatBox

struct BannerDetail: SmartCodableX {
    var id: Int?
    var url: String?
    var title: String?
    var order: Int?
    var type: Int?
    var desc: String?
    var imagePath: String?
    var amount: Decimal?
    var max: Float?
    var background: SmartHexColor?
    var height: CGFloat?
    
    static func mappingForKey() -> [SmartKeyTransformer]? {
        return [
            CodingKeys.url <--- ["github"],
        ]
    }
}
