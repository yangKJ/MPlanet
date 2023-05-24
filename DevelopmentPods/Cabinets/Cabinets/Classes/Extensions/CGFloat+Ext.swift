//
//  CGFloat+Ext.swift
//  FeatBox
//
//  Created by Condy on 2023/4/28.
//

import Foundation

extension BoxWrapper where CGFloat == Base {
    
    public var addTopSafeArea: CGFloat {
        let safeAreaHeight: CGFloat
        if #available(iOS 11.0, *) {
            safeAreaHeight = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0.0
        } else {
            safeAreaHeight = 0.0
        }
        return safeAreaHeight + base
    }
    
    public var addBottomSafeArea: CGFloat {
        let safeAreaHeight: CGFloat
        if #available(iOS 11.0, *) {
            safeAreaHeight = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0.0
        } else {
            safeAreaHeight = 0.0
        }
        return safeAreaHeight + base
    }
}
