//
//  MineSignInCalendarDTO.swift
//  WMMine
//
//  Created by Condy on 2023/9/28.
//

import Foundation
import SmartCodable
import FeatBox

struct MineSignInCalendarDTO: SmartCodableX {
    var time: TimeInterval?
    var date: Date?
    var sysDate: String?//自然日  格式: yyyyMMdd
    var tag: CalendarTagType?
}

enum CalendarTagType: String, SmartCaseDefaultable {
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
            return UIColor.fy.lightOrange
        case .establish:
            return UIColor.fy.lightRed
        case .expire:
            return UIColor.fy.lightBlue
        case .buy:
            return UIColor.fy.lightGreen
        }
    }
    
    var subTitleColor: UIColor? {
        switch self {
        case .buy:
            return UIColor.fy.black_333333
        default:
            return nil
        }
    }
    
    var titleFont: UIFont {
        switch self {
        case .subscribe:
            return UIFont.fy.system_12
        case .establish:
            return UIFont.fy.system_12
        case .expire:
            return UIFont.fy.system_12
        case .buy:
            return UIFont.fy.system(9)
        }
    }
    
    var subTitleFont: UIFont? {
        switch self {
        case .buy:
            return UIFont.fy.system(9)
        default:
            return nil
        }
    }
}
