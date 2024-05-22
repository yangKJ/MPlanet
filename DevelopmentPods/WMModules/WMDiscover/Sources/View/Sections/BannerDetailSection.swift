//
//  BannerDetailSection.swift
//  WMDiscover
//
//  Created by Condy on 2021/1/24.
//

import Foundation
import RxDataSources
import FeatBox

enum BannerDetailSectionItem {
    case top(item: [Banner])
    case detail(item: BannerDetail?)
}

enum BannerDetailSection {
    case top(items: [BannerDetailSectionItem])
    case detail(items: [BannerDetailSectionItem])
}

extension BannerDetailSection: SectionModelType {
    typealias Item = BannerDetailSectionItem
    
    var items: [BannerDetailSectionItem] {
        switch self {
        case .top(let items):
            return items
        case .detail(let items):
            return items
        }
    }
    
    init(original: BannerDetailSection, items: [BannerDetailSectionItem]) {
        switch original {
        case .top:
            self = BannerDetailSection.top(items: items)
        case .detail:
            self = BannerDetailSection.detail(items: items)
        }
    }
}
