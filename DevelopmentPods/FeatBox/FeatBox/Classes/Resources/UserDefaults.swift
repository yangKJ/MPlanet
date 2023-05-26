//
//  UserDefaults.swift
//  FeatBox
//
//  Created by Condy on 2023/5/24.
//

import Foundation
import Extensions

public struct UserDefaults {
    
    public static var shared = UserDefaults()
    
    @UserDefault_("root_manager_open_mourning_mode", defaultValue: false)
    public var mourning: Bool
    
    @UserDefault_("golbal_font_size_type", defaultValue: FontSizeType.standard.deltaFontSize)
    public var fontSize: CGFloat
}
