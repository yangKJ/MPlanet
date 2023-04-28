//
//  Banner.swift
//  WMDiscover
//
//  Created by Condy on 2023/4/28.
//

import Foundation
import HandyJSON

struct Banner: HandyJSON {
    var id: Int?
    var url: String?
    var title: String?
    var order: Int?
    var type: Int?
    var desc: String?
    var imagePath: String?
}
