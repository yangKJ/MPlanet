//
//  ApiResponse.swift
//  FeatBox
//
//  Created by Condy on 2025/1/1.
//

import Foundation
import SmartCodable

public struct ApiResponse<T: SmartCodableX>: SmartCodableX {
    
    public var code: Int?
    
    public var message: String?
    
    public var data: T?
    
    public var isSuccess: Bool {
        guard let code = code else {
            return false
        }
        return 200 ..< 300 ~= code
    }
    
    public static func mappingForKey() -> [SmartKeyTransformer]? {
        return [
            CodingKeys.data <--- ["list", "data"],
            CodingKeys.message <--- ["message", "msg"],
        ]
    }
    
    public init() { }
}
