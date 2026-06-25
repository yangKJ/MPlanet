//
//  RootAppDelegate.swift
//  RootManager
//
//  Created by Condy on 2023/3/13.
//

import Foundation
import AppMain
import FeatBox

/// 根控制器配置
class RootAppDelegate: AppDelegateType {
    
    lazy var visualEffectView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        view.frame = UIScreen.main.bounds
        return view
    }()

    weak var keyWindow: UIWindow?
    
    init(window: UIWindow?) {
        self.keyWindow = window
    }
}

extension RootAppDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let vc = AppMain.AppMainUtil.rootViewController()
        keyWindow?.rootViewController = vc
        keyWindow?.backgroundColor = UIColor.fy.mainColor
        keyWindow?.makeKeyAndVisible()

        // 悼念模式
        Mourning.setupMournMode()

        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        if visualEffectView.superview == nil {
            keyWindow?.addSubview(visualEffectView)
        }
        keyWindow?.fy.closeKeyboard()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        visualEffectView.removeFromSuperview()
        Mourning.closeMournMode()
    }
}
