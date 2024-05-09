//
//  SubscribeProxy.swift
//  RxSkeletonView
//
//  Created by Condy on 2022/2/5.
//

import Foundation
import RxCocoa
@_exported import RxSwift

extension ObservableType {
    
    func subscribeProxyDataSource<P: DelegateProxyType>(object: UIView,
                                                        dataSource: P.Delegate,
                                                        retainDelegate: Bool,
                                                        binding: @escaping (P, Event<Element>) -> Void) -> Disposable {
        let parentObject = object as! P.ParentObject
        let proxy = P.proxy(for: parentObject)
        let disposable = P.installForwardDelegate(dataSource, retainDelegate: retainDelegate, onProxyForObject: parentObject)
        // this is needed to flush any delayed old state (https://github.com/RxSwiftCommunity/RxDataSources/pull/75)
        object.layoutIfNeeded()
        let observer = self.asObservable()
            .observe(on: MainScheduler.instance)
            .`catch` { _ in Observable.empty() }
            .concat(Observable.never())
            .take(until: object.rx.deallocated)
            .subscribe({ event in
                binding(proxy, event)
                if case .error(_) = event {
                    disposable.dispose()
                } else if case .completed = event {
                    disposable.dispose()
                }
            })
        return Disposables.create { [weak object] in
            observer.dispose()
            object?.layoutIfNeeded()
            disposable.dispose()
        }
    }
}
