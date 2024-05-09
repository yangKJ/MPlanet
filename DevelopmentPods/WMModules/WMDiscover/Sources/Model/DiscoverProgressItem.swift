//
//  DiscoverProgressItem.swift
//  WMDiscover
//
//  Created by Condy on 2023/10/7.
//

import Foundation
import HandyJSON

struct DiscoverProgressItem: HandyJSON {
    var title: String?
    var desc: String?
    var isProgressed = false
    var solid = false
}
