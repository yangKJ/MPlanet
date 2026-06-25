//
//  HasScrollViewable.swift
//  Alamofire
//
//  Created by Condy on 2025/5/20.
//

import Foundation
import RxSwift
import RxRelay

public protocol HasScrollViewable: NSObjectProtocol {
    var realScrollView: UIScrollView { get }
    var isScrollByCustomer: Bool { get set }
    var isBottomOnce: Bool { get set }
    var scrollPercent: BehaviorRelay<CGFloat> { get set }
}

fileprivate var HasScrollViewableScrollPercent: UInt8 = 0
fileprivate var HasScrollViewableIsScrollByCustomer: UInt8 = 0
fileprivate var HasScrollViewableIsBottomOnce: UInt8 = 0

extension HasScrollViewable {

    public var scrollPercent: BehaviorRelay<CGFloat> {
        get {
            if let value = objc_getAssociatedObject(self, &HasScrollViewableScrollPercent) {
                return value as! BehaviorRelay<CGFloat>
            } else {
                let value: BehaviorRelay<CGFloat> = BehaviorRelay(value: 0.0)
                objc_setAssociatedObject(self, &HasScrollViewableScrollPercent, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return value
            }
        }
        set {
            objc_setAssociatedObject(self, &HasScrollViewableScrollPercent, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public var isBottomOnce: Bool {
        get {
            return self.synchronizedBag {
                return objc_getAssociatedObject(self, &HasScrollViewableIsBottomOnce) as? Bool ?? false
            }
        }
        set {
            self.synchronizedBag {
                objc_setAssociatedObject(self, &HasScrollViewableIsBottomOnce, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    public var isScrollByCustomer: Bool {
        get {
            return self.synchronizedBag {
                return objc_getAssociatedObject(self, &HasScrollViewableIsScrollByCustomer) as? Bool ?? false
            }
        }
        set {
            self.synchronizedBag {
                objc_setAssociatedObject(self, &HasScrollViewableIsScrollByCustomer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    private func synchronizedBag<T>(_ action: () -> T) -> T {
        objc_sync_enter(self)
        // why: defer 紧跟 enter 之后立即声明,确保即便 action 中断(throw/return),
        // 锁也能被释放,避免下一次访问进入死锁。
        defer { objc_sync_exit(self) }
        let result = action()
        return result
    }
}
