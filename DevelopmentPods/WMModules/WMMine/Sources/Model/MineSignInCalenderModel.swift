//
//  MineSignInCalenderModel.swift
//  WMMine
//
//  Created by Condy on 2023/9/28.
//

import Foundation
import HandyJSON

struct MineSignInCalenderModel: HandyJSON {
    var time: TimeInterval?
    var date: Date?
    var sysDate: String?//自然日  格式: yyyyMMdd
    var tag: String?
    var tagEnum: CalenderTagType? {
        guard let tag = tag else {
            return nil
        }
        return CalenderTagType(rawValue: tag)
    }
    
//    mutating func mapping(mapper: HelpingMapper) {
//        mapper <<<
//            tagEnum <-- EnumTransform<CalenderTagType>()
//    }
}

enum CalenderTagType: String {
    case subscribe = "SUBSCRIBE"
    case establish = "ESTABLISH"
    case expire = "EXPIRE"
    case buy = "BUY"
    
    var title: String {
        switch self {
        case .subscribe:
            return "认购"
        case .establish:
            return "成立"
        case .expire:
            return "到期"
        case .buy:
            return "申购"
        }
    }
    // 副标题
    var subTitle: String? {
        switch self {
        case .buy:
            return "赎回"
        default:
            return nil
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .subscribe:
            return UIColor.init(hex: "#189BE9")
        case .establish:
            return UIColor.init(hex: "#FFC000")
        case .expire:
            return UIColor.init(hex: "#68D780")
        case .buy:
            return UIColor.init(hex: "#38D3CD")
        }
    }
    
    var subTitleColor: UIColor? {
        switch self {
        case .buy:
            return UIColor.init(hex: "#FF5C10")
        default:
            return nil
        }
    }
    
    var titleFont: UIFont {
        switch self {
        case .subscribe:
            return UIFont.systemFont(ofSize: 12)
        case .establish:
            return UIFont.systemFont(ofSize: 12)
        case .expire:
            return UIFont.systemFont(ofSize: 12)
        case .buy:
            return UIFont.systemFont(ofSize: 9)
        }
    }
    
    var subTitleFont: UIFont? {
        switch self {
        case .buy:
            return UIFont.systemFont(ofSize: 9)
        default:
            return nil
        }
    }
}
