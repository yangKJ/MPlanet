//
//  UserDefaults.swift
//  FeatBox
//
//  Created by Condy on 2023/5/24.
//

import Foundation
import Cabinets

public struct UserDefaults {
    
    static let shared = UserDefaults()
    
    @UserDefault("root_manager_open_mourning_mode", defaultValue: false)
    public var mourning: Bool
    
    @UserDefault("golbal_font_size_type", defaultValue: .standard)
    public var fontSizeType: FontSizeType
}
