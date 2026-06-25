import Foundation
import RxSwift
import ObjectiveC

fileprivate var NSDisposeBagContext: UInt8 = 0

extension Reactive where Base: AnyObject {
    
    /// a unique DisposeBag that is related to the Reactive.Base instance only for Reference type
    public var disposeBag: DisposeBag {
        get {
            return synchronizedBag {
                if let disposeObject = objc_getAssociatedObject(base, &NSDisposeBagContext) as? DisposeBag {
                    return disposeObject
                }
                let disposeObject = DisposeBag()
                objc_setAssociatedObject(base, &NSDisposeBagContext, disposeObject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return disposeObject
            }
        }
        set {
            synchronizedBag {
                objc_setAssociatedObject(base, &NSDisposeBagContext, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    private func synchronizedBag<T>( _ action: () -> T) -> T {
        objc_sync_enter(self.base)
        // why: defer 紧跟 enter 之后立即声明,即便 action 中断也能保证锁被释放,
        // 防止下一次 disposeBag 访问进入死锁。
        defer { objc_sync_exit(self.base) }
        let result = action()
        return result
    }
}
