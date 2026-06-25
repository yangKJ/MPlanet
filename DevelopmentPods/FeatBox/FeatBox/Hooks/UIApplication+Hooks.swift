//
//  UIApplication+Hooks.swift
//  Alamofire
//
//  Created by Condy on 2025/3/28.
//

import Foundation
import ProductLib

extension UIApplication {
    
    public static func hooking() {
        Swizzle<UIApplication>.swapInstanceMethods(methods: [
            (#selector(UIApplication.openURL(_:)), #selector(hookedOpenURL(_:))),
        ])
    }
    
    // Fixed UIApplication.shared.open iOS 18+
    @objc dynamic func hookedOpenURL(_ url: URL) -> Bool {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        return true
    }
}
