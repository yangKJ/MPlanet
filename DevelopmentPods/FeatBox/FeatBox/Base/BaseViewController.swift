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
    
    var willCloseByUserBlock2: ((_ vc: BasicsViewController) -> Void)?
    var closedByUserBlock2: ((_ vc: BasicsViewController) -> Void)?
    
    /// About to close the current page. Click the back button or gesture to return.
    open override func setWillCloseByUserBlock(_ block: @escaping (_ vc: BasicsViewController) -> Void) {
        self.willCloseByUserBlock2 = block
    }
    
    /// It has been successfully closed. Click the back button or gesture to return.
    open override func setClosedByUserComplete(_ block: @escaping (_ vc: BasicsViewController) -> Void) {
        self.closedByUserBlock2 = block
    }
    
    open override func backAction() {
        popoutOrDismiss()
    }
    
    open func popoutOrDismiss(completion: (() -> Void)? = nil) {
        self.willCloseByUserBlock2?(self)
        if self.presentingViewController != nil {
            if let count = self.navigationController?.viewControllers.count, count > 1, self.navigationController?.topViewController == self {
                popout(completion: completion)
            } else if self.navigationController?.children[0] == self {
                self.dismiss(animated: true) {
                    completion?()
                    self.closedByUserBlock2?(self)
                }
            } else {
                popout(completion: completion)
            }
        } else {
            popout(completion: completion)
        }
    }
    
    private func popout(completion: (() -> Void)? = nil) {
        if let completion = completion {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            self.navigationController?.popViewController(animated: true)
            self.closedByUserBlock2?(self)
            CATransaction.commit()
        } else {
            self.navigationController?.popViewController(animated: true)
            self.closedByUserBlock2?(self)
        }
    }
}
