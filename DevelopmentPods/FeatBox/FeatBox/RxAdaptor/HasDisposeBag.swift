import Foundation
import RxSwift
import ObjectiveC

fileprivate var HasDisposeBagContext: UInt8 = 0

/// each HasDisposeBag offers a unique RxSwift DisposeBag instance
public protocol HasDisposeBag: AnyObject {
    
    /// a unique RxSwift DisposeBag instance
    var disposeBag: DisposeBag { get set }
}

extension HasDisposeBag {
    
    public var disposeBag: DisposeBag {
        get {
            return synchronizedBag {
                if let disposeObject = objc_getAssociatedObject(self, &HasDisposeBagContext) as? DisposeBag {
                    return disposeObject
                }
                let disposeObject = DisposeBag()
                objc_setAssociatedObject(self, &HasDisposeBagContext, disposeObject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return disposeObject
            }
        }
        set {
            synchronizedBag {
                objc_setAssociatedObject(self, &HasDisposeBagContext, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    private func synchronizedBag<T>( _ action: () -> T) -> T {
        objc_sync_enter(self)
        // why: defer 紧跟 enter 之后立即声明,确保即便 action 抛出/中断,
        // 锁也能被释放,避免后续线程进入 deadlock。
        defer { objc_sync_exit(self) }
        let result = action()
        return result
    }
}
