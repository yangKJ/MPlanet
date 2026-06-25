//
//  NSNotificationCenter+Rx.swift
//  FeatBox
//
//  Created by Condy on 2024/5/20.
//

import RxSwift

extension Reactive where Base: NotificationCenter {
    
    public func addObserver(for notification: Notification, object: AnyObject? = nil, queue: OperationQueue? = nil) -> Observable<Notification> {
        return Observable.create { [weak object] observer in
            let nsObserver = self.base.addObserver(forName: notification.name, object: object, queue: queue) { notification in
                observer.on(.next(notification))
            }
            return Disposables.create {
                self.base.removeObserver(nsObserver)
            }
        }
    }
}
