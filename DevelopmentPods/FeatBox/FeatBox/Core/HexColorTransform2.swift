//
//  HexColorTransform2.swift
//  FeatBox
//
//  Created by Condy on 2024/5/11.
//

import Foundation
import HandyJSON
import ProductLib

public final class HexColorTransform2: HexColorTransform {
    
    public override func transformFromJSON(_ value: Any?) -> HexColorTransform.Object? {
        if let value = value as? String, value == "MAIN" { // 主色调
            return UIColor.fy.mainColor
        }
        return super.transformFromJSON(value)
    }
}
