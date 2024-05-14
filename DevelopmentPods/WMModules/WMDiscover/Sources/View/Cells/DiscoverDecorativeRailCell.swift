//
//  DiscoverDecorativeRailCell.swift
//  WMDiscover
//
//  Created by Condy on 2023/10/7.
//

import Foundation
import FeatBox

class DiscoverDecorativeRailCell: BaseTableViewCell, HasDisposeBag {
    
    var items: [Discover.DecorativeRail] = [] {
        didSet {
            print(items)
            contentView.backgroundColor = items[0].backgroundColor
        }
    }
    
    override func setupConstraint() {
        
    }
}
