//
//  DiscoverSection.swift
//  WMDiscover
//
//  Created by Condy on 2023/10/7.
//

import Foundation
import RxDataSources
import FeatBox

enum DiscoverSectionItem {
    case progress(item: [DiscoverProgressItem])
    
    var itemHeight: CGFloat {
        switch self {
        case .progress(let item):
            if item.count == 0 || item.count == 1 {
                return 0.00002
            }
            return 60.0
        }
    }
}

enum DiscoverSection {
    case progress(items: [DiscoverSectionItem])
}

extension DiscoverSection: SectionModelType {
    typealias Item = DiscoverSectionItem
    
    var items: [DiscoverSectionItem] {
        switch self {
        case .progress(let items):
            return items
        }
    }
    
    init(original: DiscoverSection, items: [DiscoverSectionItem]) {
        switch original {
        case .progress:
            self = DiscoverSection.progress(items: items)
        }
    }
}
