//
//  UIDevice+Ext.swift
//  FeatBox
//
//  Created by Condy on 2024/5/20.
//

import UIKit

extension BoxWrapper where Base: UIDevice {
    
    public var isFullScreenDevice: Bool {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        return height / width - 16.0 / 9.0 > 0.01
    }
}
