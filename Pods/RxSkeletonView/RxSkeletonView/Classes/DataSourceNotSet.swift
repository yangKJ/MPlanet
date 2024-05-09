//
//  DataSourceNotSet.swift
//  RxSkeletonView
//
//  Created by Condy on 2022/2/5.
//

import Foundation
import SkeletonView
import ObjectiveC

internal final class SkeletonTableViewDataSourceNotSet: NSObject, SkeletonTableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("Data Source Not Set")
    }
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 0
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        fatalError("Data Source Not Set")
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        return nil
    }
}
