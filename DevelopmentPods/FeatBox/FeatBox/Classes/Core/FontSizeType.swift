//
//  FontSizeType.swift
//  FeatBox
//
//  Created by Condy on 2023/5/24.
//

import Foundation

public enum FontSizeType: Int, RawRepresentable {
    case standard = 0
    case large
    case huge
    
    public var deltaFontSize: CGFloat {
        switch self {
        case .standard:
            return 0
        case .large:
            return 4
        case .huge:
            return 6
        }
    }
    
    public var description: String {
        switch self {
        case .standard:
            return "标准"
        case .large:
            return "较大"
        case .huge:
            return "特大"
        }
    }
}
