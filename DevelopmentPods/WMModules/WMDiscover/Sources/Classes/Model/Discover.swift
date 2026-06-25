//
//  Discover.swift
//  WMDiscover
//
//  Created by Condy on 2024/5/10.
//

import Foundation
import FeatBox
import SmartCodable

struct Discover: SmartCodableX {
    
    var title: String?
    var titleEn: String?
    var sort: Int?
    var module: DiscoverGroupDetailType?
    
    @SmartAny
    var datas: [Any]?
    
    static func mappingForKey() -> [SmartKeyTransformer]? {
        return [
            CodingKeys.datas <--- ["list", "datas"],
        ]
    }
    
    func mutating(_ block: (inout Discover) -> Void) -> Discover {
        var options = self
        block(&options)
        return options
    }
}

struct DiscoverVideoClassify: SmartCodableX {
    var id: Int?
    var title: String?
    var sort: Int?
    var imagePath: String?
}

struct DiscoverDecorativeRail: SmartCodableX {
    var id: Int?
    var title: String?
    var desc: String?
    var sort: Int?
    var imagePath: String?
    var backgroundColor: SmartHexColor?
    
    static func mappingForKey() -> [SmartKeyTransformer]? {
        return [
            CodingKeys.desc <--- ["sub_title"],
        ]
    }
}

enum DiscoverGroupDetailType: String, SmartCaseDefaultable {
    case banner = "BANNER"
    case videoClassify = "VIDEO_CLASSIFY" // 视频分类
    case decorativeRail = "DECORATIVE_RAIL" // 装饰横条
    
    var hasSectionHeaderTitle: Bool {
        switch self {
        case .banner:
            return false
        case .videoClassify:
            return true
        case .decorativeRail:
            return false
        }
    }
    
    func deserialized(with value: [Any]) -> [SmartCodableX]? {
        switch self {
        case .banner:
            if let datas = value as? [Banner] {
                return datas
            }
            return [Banner].deserialize(from: value)
        case .videoClassify:
            return [DiscoverVideoClassify].deserialize(from: value)
        case .decorativeRail:
            return [DiscoverDecorativeRail].deserialize(from: value)
        }
        return nil
    }
    
    func createSection(with datas: [Any]?, title: String? = nil) -> BaseTableViewSectionable? {
        guard let datas = datas, datas.count > 0 else {
            return nil
        }
        switch self {
        case .banner:
            guard let datas = deserialized(with: datas) as? [Banner] else {
                return nil
            }
            let section = BaseTableViewHeaderFooterSection(cells: [])
            var bannerCell = BannerCellViewModel()
            bannerCell.datasource = datas.sorted(by: {
                $0.order ?? 0 < $1.order ?? 0
            })
            bannerCell.goto = true
            // 修复：原 bannerCell 无 cellHeight，cell 用自动布局撑到 200+ pt 占满首屏。固定 180pt。
            bannerCell.cellHeight = 180
            section.cells = [bannerCell]
            return section
        case .videoClassify:
            guard let datas = deserialized(with: datas) as? [DiscoverVideoClassify] else {
                return nil
            }
            var section = DiscoverVideoClassifyHeaderViewModel(cells: [])
            section.sectionHeaderViewType = DiscoverVideoClassifyHeaderView.self
            if !datas.isEmpty, title != nil {
                section.sectionHeaderHeight = UITableView.automaticDimension
            } else {
                section.sectionHeaderHeight = 0.0
            }
            section.title = title
            var videoClassifyCell = DiscoverVideoClassifyCellViewModel()
            videoClassifyCell.datasource = datas
            videoClassifyCell.cellHeight = datas.count == 0 ? 0.002 : 1
            section.cells = [videoClassifyCell]
            return section
        case .decorativeRail:
            guard let datas = deserialized(with: datas) as? [DiscoverDecorativeRail] else {
                return nil
            }
            let section = BaseTableViewHeaderFooterSection(cells: [])
            section.sectionHeaderViewType = BaseTableViewHeaderFooterView.self
            section.sectionFooterViewType = BaseTableViewHeaderFooterView.self
            // 修复：原每条数据单独一个 section，每条都带 header 10pt + footer 20pt 空白，
            // 累积起来视频赔价榜前出现大量空白。改为所有条目共属一个 section，只保留一头一尾。
            section.sectionHeaderHeight = 10
            section.sectionFooterHeight = 20
            section.sectionHeaderBackgroundColor = UIColor.fy.white
            section.sectionFooterBackgroundColor = UIColor.fy.white
            for data in datas {
                var decorativeRailCell = DiscoverDecorativeRailCellViewModel()
                decorativeRailCell.datasource = data
                section.cells.append(decorativeRailCell)
            }
            return section
        }
    }
}
