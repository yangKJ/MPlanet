//
//  UserDTO.swift
//  FeatBox
//
//  Created by Condy on 2023/8/30.
//

import Foundation
import SmartCodable

/// 登陆用户信息
public struct UserDTO: SmartCodableX {
    public var token: String?
    public var hasPrivilegeBarItem: String? // 模拟个别用户存在特殊的TabBar
    public var accountStatus: AccountType?
    
    public static func mappingForKey() -> [SmartKeyTransformer]? {
        return [
            CodingKeys.accountStatus <--- ["account_type"],
        ]
    }
    
    public init() { }
}

extension UserDTO {
    public enum AccountType: Int, SmartCaseDefaultable {
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
