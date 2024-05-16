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
    case banner(item: [Banner])
    case videoClassify(item: [Discover.VideoClassify])
    case decorativeRail(item: [Discover.DecorativeRail])
    
    var itemHeight: CGFloat {
        switch self {
        case .banner(let item):
            return UITableView.automaticDimension
        case .videoClassify(let item):
            if item.count == 0 {
                return 0.00002
            }
            return 100
        case .decorativeRail:
            return UITableView.automaticDimension
        }
    }
}

enum DiscoverSection {
    case banner(items: [DiscoverSectionItem])
    case videoClassify(title: String, items: [DiscoverSectionItem])
    case decorativeRail(items: [DiscoverSectionItem])
}

extension DiscoverSection: SectionModelType {
    typealias Item = DiscoverSectionItem
    
    var items: [DiscoverSectionItem] {
        switch self {
        case .banner(let items):
            return items
        case .videoClassify(_, let items):
            return items
        case .decorativeRail(let items):
            return items
        }
    }
    
    init(original: DiscoverSection, items: [DiscoverSectionItem]) {
        switch original {
        case .banner:
            self = DiscoverSection.banner(items: items)
        case .videoClassify(let title, _):
            self = DiscoverSection.videoClassify(title: title, items: items)
        case .decorativeRail:
            self = DiscoverSection.decorativeRail(items: items)
        }
    }
    
    var headerHeight: CGFloat {
        switch self {
        case .banner, .decorativeRail:
            return 0.0
        case .videoClassify(let title, let items):
            return (items.isEmpty || title.count == 0) ? 0.0 : UITableView.automaticDimension
        }
    }
    
    var headerView: UIView? {
        switch self {
        case .banner, .decorativeRail:
            return nil
        case .videoClassify(let title, let items):
            if items.isEmpty || title.count == 0 {
                return nil
            }
            let view = BaseView()
            let label = BaseLabel()
            label.text = title
            label.textColor = UIColor.fy.mainColor
            label.font = UIFont.fy.bold_20
            view.addSubview(label)
            let line = ZLineView(asix: .vertical, thickness: 3)
            line.backgroundColor = UIColor.fy.mainColor
            line.layer.cornerRadius = 1
            view.addSubview(line)
            line.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(15)
                make.top.bottom.equalToSuperview().inset(10)
                make.height.equalTo(20)
            }
            label.snp.makeConstraints { make in
                make.left.equalTo(line.snp.right).offset(15)
                make.centerY.equalToSuperview()
            }
            return view
        }
    }
}
