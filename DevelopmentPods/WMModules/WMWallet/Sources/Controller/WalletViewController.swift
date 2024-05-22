//
//  WalletViewController.swift
//  WMWallet
//
//  Created by Condy on 2020/12/28.
//

import UIKit
import FeatBox
import RxDataSources

class WalletViewController: BaseTableViewController<WalletViewModel>, NavigationBarHiddenable {
    
    let detailsEvent = PublishRelay<Void>()
    
    lazy var dataSource: RxTableViewSectionedReloadDataSource<WalletSection> = {
        return RxTableViewSectionedReloadDataSource(configureCell: { [weak self] (ds, tableView, indexPath, sectionItem) in
            switch sectionItem {
            case .asset(let item):
                let cell = tableView.fy.dequeueReusableCell(WalletHomeAssetCell.self)
                if let weakself = self {
                    cell.disposeBag = DisposeBag() // 解决Cell重用导致订阅取消或者多次订阅问题
                    cell.rx.tapDetails.bind(to: weakself.detailsEvent).disposed(by: cell.disposeBag)
                }
                cell.walletData = item
                return cell
            case .application(let item):
                let cell = tableView.fy.dequeueReusableCell(WalletHomeApplicationCell.self)
                cell.applicationDatas = item
                return cell
            case .token(let item):
                let cell = tableView.fy.dequeueReusableCell(WalletHomeTokenCell.self)
                cell.tokenData = item
                return cell
            }
        })
    }()
    
    lazy var topNavigationBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.fy.mainColor
        return view
    }()
    
    lazy var tokenHeaderView = WalletHomeTokenHeaderView()
    
    lazy var emptyView: UIView = {
        let view = UIView.init(frame: .zero)
        view.isHidden = true
        view.backgroundColor = UIColor.fy.mainColor.withAlphaComponent(0.3)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSubviews()
        self.setupViewModel()
        self.setupBindings()
    }
    
    override func registerTableViewCell() -> [BaseTableViewCell.Type] {
        return [
            WalletHomeAssetCell.self,
            WalletHomeApplicationCell.self,
            WalletHomeTokenCell.self
        ]
    }
    
    override func tableViewCellHeight(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSource[indexPath].itemHeight
    }
    
    override func tableViewHeaderHeight(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return dataSource[section].headerHeight
    }
    
    override func tableViewHeaderView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch dataSource[section] {
        case .asset, .application:
            return nil
        case .token:
            return tokenHeaderView
        }
    }
    
    func setupSubviews() {
        self.view.addSubview(emptyView)
        self.view.addSubview(topNavigationBarView)
        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
        let input = WalletViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.displayHomeView.drive(tableView.rx.isHidden).disposed(by: disposeBag)
        output.displayHomeView.drive(topNavigationBarView.rx.isHidden).disposed(by: disposeBag)
        output.displayEmptyView.drive(emptyView.rx.isHidden).disposed(by: disposeBag)
        
        output.sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    func setupBindings() {
        // 点击事件
        detailsEvent.subscribe(onNext: {
            print("xxsdsd")
        }).disposed(by: disposeBag)
    }
}
