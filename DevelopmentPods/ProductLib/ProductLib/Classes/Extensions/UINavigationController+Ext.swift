//
//  UINavigationController+Ext.swift
//  ProductLib
//
//  Created by Condy on 2024/5/10.
//

import Foundation

extension BoxWrapper where Base: UINavigationController {
    
    public static func navigationHeight() -> CGFloat {
        statusBarHeight() + 44.0
    }
    
    public static func statusBarHeight() -> CGFloat {
        if #available(iOS 13.0, *) {
            let statusManager = UIApplication.shared.windows.first?.windowScene?.statusBarManager
            return statusManager?.statusBarFrame.height ?? 20.0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
    public func popToRootViewController(animated: Bool, completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        base.popToRootViewController(animated: animated)
        CATransaction.commit()
    }
    
    /// Pop to specified controller.
    /// - Parameters:
    ///   - controller: Pop to view controller.
    ///   - animated: Whether to turn on the animation.
    ///   - completion: Completed block.
    public func popToViewController(_ controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        base.popToViewController(controller, animated: animated)
        CATransaction.commit()
    }
    
    /// Push to view controller and replace the last `replaceCount` view controller.
    /// - Parameters:
    ///   - controller: Push to view controller.
    ///   - replaceCount: The number of replacements, `Int.max` replace all.
    ///   - animated: Whether to turn on the animation.
    public func pushViewControllerAndReplace(_ controller: UIViewController, replaceCount: Int, animated: Bool) {
        if replaceCount == Int.max {
            base.setViewControllers([controller], animated: animated)
        } else {
            var cons = base.viewControllers
            let count = min(cons.count, replaceCount)
            cons.removeLast(count)
            cons.append(controller)
            base.setViewControllers(cons, animated: animated)
        }
    }
    
    /// Push to view controller and remove the `removeType` controller.
    /// - Parameters:
    ///   - controller: Push to view controller.
    ///   - removeType: Controllers to be removed.
    ///   - animated: Whether to turn on the animation.
    public func pushViewController(_ controller: UIViewController, removeType: UIViewController.Type, animated: Bool) {
        pushViewController(controller, removeTypes: [removeType], animated: animated)
    }
    
    /// Push to view controller and remove some the `removeTypes` controller, and add some middle controllers.
    /// - Parameters:
    ///   - controller: Push to view controller.
    ///   - middleControllers: Need add middle view controllers.
    ///   - removeTypes: Controllers to be removed.
    ///   - animated: Whether to turn on the animation.
    public func pushViewController(_ controller: UIViewController, middleControllers: [UIViewController]? = nil, removeTypes: [UIViewController.Type], animated: Bool) {
        var controllers = base.viewControllers
        var i = 0
        while i < controllers.count {
            if controllers.indices.contains(i), removeTypes.contains(where: {
                type(of: controllers[i]) == $0
            }) {
                controllers.remove(at: i)
                i -= 1
            }
            i += 1
        }
        if let middleControllers = middleControllers {
            controllers += middleControllers
        }
        controllers.append(controller)
        base.setViewControllers(controllers, animated: animated)
    }
    
    public func popToPreviousViewController(of previousTypes: [UIViewController.Type], animated: Bool) {
        let cons = base.viewControllers
        var i = 0
        var foundIndex = NSNotFound
        while i < cons.count {
            if cons.indices.contains(i), previousTypes.contains(where: {
                type(of: cons[i]) == $0
            }) {
                foundIndex = i
                break
            }
            i += 1
        }
        if foundIndex != NSNotFound {
            if foundIndex <= cons.count {
                let controller = cons[foundIndex - 1]
                base.popToViewController(controller, animated: animated)
            } else {
                base.popToRootViewController(animated: animated)
            }
        } else {
            base.popViewController(animated: animated)
        }
    }
    
    /// Gets the specified controller in the stack.
    public func stackAppointedViewController<T: UIViewController>(_ type_: T.Type) -> T? {
        for vc in base.viewControllers where type(of: vc) == type_ {
            return vc as? T
        }
        return nil
    }
}
