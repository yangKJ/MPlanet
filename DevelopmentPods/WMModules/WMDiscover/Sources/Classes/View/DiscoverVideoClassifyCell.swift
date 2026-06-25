//
//  DiscoverVideoClassifyCell.swift
//  WMDiscover
//
//  Created by Condy on 2023/10/7.
//

import Foundation
import FeatBox

class DiscoverVideoClassifyCellViewModel: BaseTableViewCellViewModelable {
    var cellType: FeatBox.BaseTableViewCell.Type {
        DiscoverVideoClassifyCell.self
    }
}

class DiscoverVideoClassifyCell: BaseTableViewCell, HasDisposeBag {
    
    override var viewModel: BaseTableViewCellViewModelable? {
        didSet {
            guard let viewModel = viewModel as? DiscoverVideoClassifyCellViewModel else {
                return
            }
            
        }
    }
    
    lazy var stackView: UIView = {
        let stack = UIStackView(frame: .zero)
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 10
        stack.distribution = .fillEqually
        return stack
    }()
    
    override func setupConstraint() {
        contentView.backgroundColor = UIColor.fy.white
        contentView.addSubview(stackView)
        
    }
}
