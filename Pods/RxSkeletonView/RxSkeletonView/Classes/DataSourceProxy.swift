//
//  DataSourceProxy.swift
//  RxSkeletonView
//
//  Created by Condy on 2022/2/5.
//

import Foundation
import SkeletonView
import RxCocoa

class SkeletonTableDataSourceProxy: DelegateProxy<UITableView, SkeletonTableViewDataSource> {
    
    public private(set) weak var tableView: UITableView?
    lazy var dataSource: SkeletonTableViewDataSource? = SkeletonTableViewDataSourceNotSet()
    
    public init(tableView: UITableView) {
        self.tableView = tableView
        super.init(parentObject: tableView, delegateProxy: SkeletonTableDataSourceProxy.self)
    }
    
    /// For more information take a look at `DelegateProxyType`.
    public override func setForwardToDelegate(_ forwardToDelegate: SkeletonTableViewDataSource?, retainDelegate: Bool) {
        if let forwardToDelegate = forwardToDelegate {
            dataSource = forwardToDelegate
        }
        super.setForwardToDelegate(forwardToDelegate, retainDelegate: retainDelegate)
    }
    
    // MARK: - UITableViewDataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource!.tableView(tableView, numberOfRowsInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dataSource!.tableView(tableView, cellForRowAt: indexPath)
    }
}

extension SkeletonTableDataSourceProxy: DelegateProxyType {
    
    /// It is require that enumerate call `register` of the extended DelegateProxy subclasses here.
    public static func registerKnownImplementations() {
        self.register { SkeletonTableDataSourceProxy(tableView: $0) }
    }
    
    public static func currentDelegate(for object: UITableView) -> SkeletonTableViewDataSource? {
        return object.dataSource as? SkeletonTableViewDataSource
    }
    
    public static func setCurrentDelegate(_ delegate: SkeletonTableViewDataSource?, to object: UITableView) {
        object.dataSource = delegate
    }
}

extension SkeletonTableDataSourceProxy: SkeletonTableViewDataSource {
    
    public func numSections(in collectionSkeletonView: UITableView) -> Int {
        return dataSource!.numSections(in: collectionSkeletonView)
    }
    
    public func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource!.collectionSkeletonView(skeletonView, numberOfRowsInSection: section)
    }
    
    public func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return dataSource!.collectionSkeletonView(skeletonView, cellIdentifierForRowAt: indexPath)
    }
    
    public func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        return dataSource!.collectionSkeletonView(skeletonView, skeletonCellForRowAt: indexPath)
    }
}
