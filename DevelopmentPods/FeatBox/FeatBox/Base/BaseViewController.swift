//
//  BaseViewController.swift
//  FeatBox
//
//  Created by Condy on 2023/5/20.
//

import Foundation
import Rickenbacker
import ProductLib

open class BaseViewController<T: BaseViewModel>: Rickenbacker.VMViewController<T> {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.fy.background
    }
}
