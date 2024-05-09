//
//  UIWindow+Ext.swift
//  Extensions
//
//  Created by Condy on 2023/8/30.
//

import UIKit

extension BoxWrapper where Base: UIWindow {
    
    public static func keyWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .first(where: { $0 is UIWindowScene })
                .flatMap({ $0 as? UIWindowScene })?.windows
                .first(where: \.isKeyWindow)
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
