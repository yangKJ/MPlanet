//
//  DiscoverProgressCell.swift
//  WMDiscover
//
//  Created by Condy on 2023/10/7.
//

import Foundation
import FeatBox

class DiscoverProgressCell: BaseTableViewCell, HasDisposeBag {
    
    var items: [DiscoverProgressItem] = [] {
        didSet {
            print(items)
        }
    }
    
    override func setupConstraint() {
        
    }
}
