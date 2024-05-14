//
//  DiscoverVideoClassifyCell.swift
//  WMDiscover
//
//  Created by Condy on 2023/10/7.
//

import Foundation
import FeatBox

class DiscoverVideoClassifyCell: BaseTableViewCell, HasDisposeBag {
    
    var items: [Discover.VideoClassify] = [] {
        didSet {
            print(items)
        }
    }
    
    override func setupConstraint() {
        
    }
}
