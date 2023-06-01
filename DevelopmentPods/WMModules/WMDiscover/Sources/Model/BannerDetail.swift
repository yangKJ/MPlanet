//
//  BannerDetail.swift
//  WMDiscover
//
//  Created by Condy on 2023/5/29.
//

import Foundation
import HandyJSON
import RxNetworks

struct BannerDetail: HandyJSON {
    var id: Int?
    var url: String?
    var title: String?
    var order: Int?
    var type: Int?
    var desc: String?
    var imagePath: String?
    var amount: NSDecimalNumber?
    var max: Float?
    
    var background: UIColor?
    var height: CGFloat?
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            url <-- "github"
        mapper <<<
            amount <-- DecimalNumberTransform()
    }
}
