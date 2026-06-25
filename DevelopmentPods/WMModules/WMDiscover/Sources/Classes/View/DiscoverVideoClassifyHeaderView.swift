//
//  DiscoverVideoClassifyHeaderView.swift
//  WMDiscover
//
//  Created by Condy on 2024/12/30.
//

import Foundation
import FeatBox

class DiscoverVideoClassifyHeaderViewModel: BaseTableViewSectionable {
    
    var title: String?
    
    var cells: [BaseTableViewCellViewModelable]
    
    init(cells: [BaseTableViewCellViewModelable]) {
        self.cells = cells
        self.sectionFooterBackgroundColor = .clear
        self.sectionHeaderBackgroundColor = .clear
    }
}

class DiscoverVideoClassifyHeaderView: BaseTableViewHeaderFooterView {
    
    lazy var titleLabel: BaseLabel = {
        let label = BaseLabel.init(frame: .zero)
        label.textColor = UIColor.fy.mainColor
        label.font = UIFont.fy.bold_18
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    lazy var line: ZLineView = {
        let line = ZLineView(asix: .vertical, thickness: 3)
        line.backgroundColor = UIColor.fy.mainColor
        line.layer.cornerRadius = 1
        return line
    }()
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    open override func refreshViews() {
        super.refreshViews()
        guard let sectionViewModel = sectionViewModel as? DiscoverVideoClassifyHeaderViewModel else {
            return
        }
        titleLabel.text = sectionViewModel.title
    }
    
    private func setupViews() {
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.line)
        line.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.top.bottom.equalToSuperview().inset(10)
            make.height.equalTo(20)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(line.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
    }
}
