//
//  LoggedDTO.swift
//  FeatBox
//
//  Created by Condy on 2023/8/30.
//

import Foundation
import HandyJSON

/// 登陆信息
public struct LoggedDTO: HandyJSON {
    
    public var token: String?
    
    public var accountStatus: AccountType?
    
    public mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            accountStatus <-- "account_type"
        mapper <<<
            accountStatus <-- EnumTransform<AccountType>()
    }
    
    public init() { }
}

extension LoggedDTO {
    public enum AccountType: Int {
        case normal = 0
        case aberrant
        
        public var des: String {
            switch self {
            case .normal:
                return Res.text("正常的")
            case .aberrant:
                return Res.text("异常的")
            }
        }
    }
}
