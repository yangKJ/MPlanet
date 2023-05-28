//
//  WalletSection.swift
//  WMWallet
//
//  Created by Condy on 2021/1/24.
//

import Foundation
import RxDataSources
import FeatBox

enum WalletSectionItem {
    case asset(item: WalletData)
    case application(item: [WalletApplicationData])
    case token(item: WalletTokenData)
    
    var itemHeight: CGFloat {
        switch self {
        case .asset(let item):
            return 240
        case .application(let item):
            return 120
        case .token(let item):
            return 70 + 12
        }
    }
}

enum WalletSection {
    case asset(items: [WalletSectionItem])
    case application(items: [WalletSectionItem])
    case token(items: [WalletSectionItem])
}

extension WalletSection: SectionModelType {
    typealias Item = WalletSectionItem
    
    var items: [WalletSectionItem] {
        switch self {
        case .asset(let items):
            return items
        case .application(let items):
            return items
        case .token(let items):
            return items
        }
    }
    
    init(original: WalletSection, items: [WalletSectionItem]) {
        switch original {
        case .asset:
            self = WalletSection.asset(items: items)
        case .application:
            self = WalletSection.application(items: items)
        case .token:
            self = WalletSection.token(items: items)
        }
    }
    
    var headerHeight: CGFloat {
        switch self {
        case .asset, .application:
            return 0.0
        case .token(let items):
            return items.isEmpty ? 0.0 : 60.0
        }
    }
}
