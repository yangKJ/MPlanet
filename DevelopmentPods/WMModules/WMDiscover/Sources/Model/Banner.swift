//
//  Banner.swift
//  WMDiscover
//
//  Created by Condy on 2023/4/28.
//

import Foundation
import HandyJSON
import RxNetworks
import Harbeth

struct Banner: HandyJSON {
    var id: Int?
    var cardNo: String?
    var url: String?
    var title: String?
    var order: Int?
    var type: Int?
    var desc: String?
    var imagePath: String?
    var amount: NSDecimalNumber?
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            url <-- "github"
        mapper <<<
            amount <-- DecimalNumberTransform()
    }
    
    var filters: [C7FilterProtocol]? {
        switch id {
        case 20:
            return [
                C7ColorMatrix4x4(matrix: Matrix4x4.Color.polaroid),
                C7Granularity(grain: 0.8),
            ]
        case 29:
            return [
                C7SoulOut(soul: 0.75),
                C7Storyboard(ranks: 2),
            ]
        default:
            return nil
        }
    }
}
