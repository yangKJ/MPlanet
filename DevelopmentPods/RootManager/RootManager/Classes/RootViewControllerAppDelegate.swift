//
//  RootViewControllerAppDelegate.swift
//  RootManager
//
//  Created by Condy on 2023/3/13.
//

import Foundation
import AppMain
import FeatBox

/// 根控制器配置
class RootViewControllerAppDelegate: AppDelegateType {
    
    weak var keyWindow: UIWindow?
    
    lazy var visualEffectView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        view.frame = UIScreen.main.bounds
        return view
    }()
    
    init(window: UIWindow?) {
        if let window = window {
            window.backgroundColor = UIColor.fy.white
        }
        self.keyWindow = window
    }
}

extension RootViewControllerAppDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let vc = AppMain.AppMainUtil.rootViewController()
        keyWindow?.rootViewController = vc
        keyWindow?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        application.keyWindow?.addSubview(visualEffectView)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        visualEffectView.removeFromSuperview()
    }
}
