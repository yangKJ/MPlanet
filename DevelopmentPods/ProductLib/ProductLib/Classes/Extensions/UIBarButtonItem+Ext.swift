//
//  UIBarButtonItem+Ext.swift
//  FeatBox
//
//  Created by Condy on 2024/5/20.
//

import Foundation

extension BoxWrapper where Base == UIBarButtonItem {
    
    public static func spaceButton() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }
}
