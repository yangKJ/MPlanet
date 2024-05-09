//
//  RxTableView.swift
//  RxSkeletonView
//
//  Created by Condy on 2022/2/5.
//

import UIKit
import RxSwift
import RxCocoa
@_exported import SkeletonView
@_exported import RxDataSources

extension Reactive where Base: UITableView {
    
    public func skeletonItems<T: RxTableViewDataSourceType & SkeletonTableViewDataSource,
                              O: ObservableType>(dataSource: T)
    -> (_ source: O) -> Disposable where T.Element == O.Element {
        return { (source) in
            // This is make sure delegate proxy is in place when data source is being bound.
            // This is needed because theoretically the data source subscription itself might call `self.rx.delegate`.
            // Therefore it's better to set delegate proxy first, just to be sure.
            _ = self.base.delegate
            // Strong reference is needed because data source is in use until result subscription is disposed
            return source.subscribeProxyDataSource(object: self.base,
                                                   dataSource: dataSource,
                                                   retainDelegate: true,
                                                   binding: { [weak tableView = self.base]
                (_: SkeletonTableDataSourceProxy, observedEvent) -> Void in
                if let tableView = tableView {
                    dataSource.tableView(tableView, observedEvent: observedEvent)
                }
            })
        }
    }
}
