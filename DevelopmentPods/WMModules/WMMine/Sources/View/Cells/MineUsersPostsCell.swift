//
//  MineUsersPostsCell.swift
//  WMMine
//
//  Created by Condy on 2023/6/6.
//

import Foundation
import FeatBox

class MineUsersPostsCell: BaseTableViewCell {
    
    public let posts = BehaviorRelay<[MinePostsDetail]>(value: [])
    
}
