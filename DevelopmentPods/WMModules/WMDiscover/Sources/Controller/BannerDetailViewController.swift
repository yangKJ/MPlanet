//
//  BannerDetailViewController.swift
//  WMDiscover
//
//  Created by Condy on 2023/5/29.
//

import Foundation
import FeatBox

class BannerDetailViewController: BaseTableViewController<BannerDetailViewModel> {
    
    public var list: [Banner] = []
    public var index: Int = 0
    public var banner: Banner?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInit()
        self.setupSubviews()
        self.setupViewModel()
        self.setupBindings()
    }
    
    override func registerTableViewCell() -> [BaseTableViewCell.Type] {
        return [BannerDetailTopListCell.self]
    }
    
    func setupInit() {
        self.title = self.banner?.title
    }
    
    func setupSubviews() {
        
    }
    
    func setupViewModel() {
        let input = BannerDetailViewModel.Input(banners: list, index: index)
        let output = viewModel.transform(input: input)
        
//        output.sections
//            .bind(to: tableView.rx.items(dataSource: dataSource))
//            .disposed(by: disposeBag)
    }
    
    func setupBindings() {
        
    }
}

extension BannerDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
