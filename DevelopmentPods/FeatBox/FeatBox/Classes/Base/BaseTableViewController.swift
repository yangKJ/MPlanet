//
//  BaseTableViewController.swift
//  FeatBox
//
//  Created by Condy on 2023/4/29.
//

import Foundation
import Rickenbacker
import Extensions

open class BaseTableViewController<T: BaseViewModel>: Rickenbacker.VMTableViewController<T>, UIScrollViewDelegate {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.ai.background
        tableView.backgroundColor = UIColor.ai.background
        tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        if self is NavigationBarHiddenable {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}
