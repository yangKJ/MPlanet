//
//  BannerDetailViewController.swift
//  WMDiscover
//
//  Created by Condy on 2023/5/29.
//

import Foundation
import FeatBox

class BannerDetailViewController: BaseTableViewController<BannerDetailViewModel>, NavigationBarHiddenable {
    
    public var list: [Banner] = []
    public var selectIndex: Int = 0
    
    private lazy var topNavigationBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ai.mainColor
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSubviews()
        self.setupViewModel()
        self.setupBindings()
    }
    
    override func registerTableViewCell() -> [BaseTableViewCell.Type] {
        return [BannerDetailTopListCell.self]
    }
    
    func setupSubviews() {
        self.view.addSubview(topNavigationBarView)
        topNavigationBarView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(88)
        }
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(topNavigationBarView.snp.bottom)
            make.bottom.equalTo(self.view.snp.bottomMargin)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func setupViewModel() {
        let input = BannerDetailViewModel.Input(banners: list)
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
