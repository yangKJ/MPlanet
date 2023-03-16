//
//  WMNavigationController.swift
//  AppMain
//
//  Created by Condy on 2020/12/29.
//

import UIKit
import Rickenbacker

class WMNavigationController: BaseNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
}
