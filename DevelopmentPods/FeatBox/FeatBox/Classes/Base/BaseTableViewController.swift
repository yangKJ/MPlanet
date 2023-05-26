//
//  BaseTableViewController.swift
//  FeatBox
//
//  Created by Condy on 2023/4/29.
//

import Foundation
import Rickenbacker
import Extensions

open class BaseTableViewController<T: BaseViewModel>: Rickenbacker.VMTableViewController<T> {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.ai.background
    }
}
