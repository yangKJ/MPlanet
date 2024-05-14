//
//  Discover.swift
//  WMDiscover
//
//  Created by Condy on 2024/5/10.
//

import Foundation
import HandyJSON
import FeatBox

struct Discover: HandyJSON {
    
    var module: DiscoverGroupDetailType?
    var title: String?
    var titleEn: String?
    var sort: Int?
    var list: Array<Dictionary<String, Any>>?
    
    /// 本地转换`list`而来
    var datas: [HandyJSON]?
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            module <-- EnumTransform<DiscoverGroupDetailType>()
    }
    
    func mutating(_ block: (inout Discover) -> Void) -> Discover {
        var options = self
        block(&options)
        return options
    }
}

extension Discover {
    
    struct VideoClassify: HandyJSON {
        var id: Int?
        var title: String?
        var sort: Int?
        var imagePath: String?
    }
    
    struct DecorativeRail: HandyJSON {
        var id: Int?
        var title: String?
        var desc: String?
        var sort: Int?
        var imagePath: String?
        var backgroundColor: UIColor?
        
        mutating func mapping(mapper: HelpingMapper) {
            mapper <<<
                desc <-- "sub_title"
            mapper <<<
                backgroundColor <-- "background_color"
            mapper <<<
                backgroundColor <-- HexColorTransform2()
        }
    }
}

enum DiscoverGroupDetailType: String {
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
    
    func deserialized(with value: Any?) -> [HandyJSON]? {
        guard let value = value as? Array<Dictionary<String, Any>> else {
            return nil
        }
        switch self {
        case .banner:
            return [Banner].deserialize(from: value)?.compactMap({ $0 })
        case .videoClassify:
            return [Discover.VideoClassify].deserialize(from: value)?.compactMap({ $0 })
        case .decorativeRail:
            return [Discover.DecorativeRail].deserialize(from: value)?.compactMap({ $0 })
        }
    }
    
    func createSection(with datas: [HandyJSON]?, title: String? = nil) -> DiscoverSection? {
        guard let datas = datas, datas.count > 0 else {
            return nil
        }
        switch self {
        case .banner:
            guard let datas = datas as? [Banner] else {
                return nil
            }
            return DiscoverSection.banner(items: [.banner(item: datas)])
        case .videoClassify:
            guard let datas = datas as? [Discover.VideoClassify] else {
                return nil
            }
            return DiscoverSection.videoClassify(title: title ?? "", items: [.videoClassify(item: datas)])
        case .decorativeRail:
            guard let datas = datas as? [Discover.DecorativeRail] else {
                return nil
            }
            return DiscoverSection.decorativeRail(items: [.decorativeRail(item: datas)])
        }
    }
}
