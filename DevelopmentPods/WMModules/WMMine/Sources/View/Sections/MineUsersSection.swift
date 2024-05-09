//
//  MineUsersSection.swift
//  WMMine
//
//  Created by Condy on 2023/6/6.
//

import Foundation
import RxDataSources
import FeatBox

enum MineUsersSectionItem {
    case header(item: MineUsers?)
    case photo(item: [MinePhotoAlbum])
    case ranking(item: String)
    case posts(item: [MinePostsDetail])
    
    var itemHeight: CGFloat {
        switch self {
        case .header:
            return 160
        case .photo:
            return 120
        case .ranking:
            return 50
        case .posts:
            return UITableView.automaticDimension
        }
    }
    
    var type: BaseTableViewCell.Type {
        switch self {
        case .header:
            return MineUsersHeaderCell.self
        case .photo:
            return MineUsersPhotoCell.self
        case .ranking:
            return MineUsersRankingCell.self
        case .posts:
            return MineUsersPostsCell.self
        }
    }
}

enum MineUsersSection {
    case header(items: [MineUsersSectionItem])
    case photo(items: [MineUsersSectionItem])
    case ranking(items: [MineUsersSectionItem])
    case posts(items: [MineUsersSectionItem])
}

extension MineUsersSection: SectionModelType {
    typealias Item = MineUsersSectionItem
    
    var items: [MineUsersSectionItem] {
        switch self {
        case .header(let items):
            return items
        case .photo(let items):
            return items
        case .ranking(let items):
            return items
        case .posts(let items):
            return items
        }
    }
    
    init(original: MineUsersSection, items: [MineUsersSectionItem]) {
        switch original {
        case .header:
            self = MineUsersSection.header(items: items)
        case .photo:
            self = MineUsersSection.photo(items: items)
        case .ranking:
            self = MineUsersSection.ranking(items: items)
        case .posts:
            self = MineUsersSection.posts(items: items)
        }
    }
}
