//
//  ExUIApplication.swift
//  FeatBox
//
//  Created by Condy on 2020/11/23.
//

import UIKit

public func UIApplicationAdjustStatusBarBackgroundColor(_ color: UIColor) {
    if let statusBarWindow = UIApplication.shared.value(forKey: "statusBarWindow") as? UIView,
        let statusBar = statusBarWindow.value(forKey: "statusBar") as? UIView {
        statusBar.backgroundColor = color
    }
}
