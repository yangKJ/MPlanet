//
//  UINavigationController+Ext.swift
//  ProductLib
//
//  Created by Condy on 2024/5/10.
//

import Foundation

extension BoxWrapper where Base: UINavigationController {
    
    public func popToRootViewController(animated: Bool, completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        base.popToRootViewController(animated: animated)
        CATransaction.commit()
    }
    
    public func popToViewController(_ controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        base.popToViewController(controller, animated: animated)
        CATransaction.commit()
    }
}
