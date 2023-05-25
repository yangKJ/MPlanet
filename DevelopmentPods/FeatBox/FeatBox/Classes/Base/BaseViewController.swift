//
//  BaseViewController.swift
//  FeatBox
//
//  Created by Condy on 2023/5/20.
//

import Foundation
import Rickenbacker
import Contacts

open class BaseViewController: Rickenbacker.BasicsViewController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.ai.background
    }
}
