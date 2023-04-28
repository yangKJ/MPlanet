//
//  WalletHomeView.swift
//  WMWallet
//
//  Created by Condy on 2020/12/28.
//

import UIKit
import FeatBox
import Rickenbacker
import RxDataSources

class WalletHomeView: UIView, UIScrollViewDelegate {
    
    let detailsEvent = PublishRelay<Void>()
    lazy var dataSource = tableViewSectionedReloadDataSource()
    
    lazy var topView = WalletHomeTopView()
    lazy var tokenHeaderView = WalletHomeTokenHeaderView()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        tableView.rx.itemSelected.bind {
            tableView.deselectRow(at: $0, animated: false)
        }.disposed(by: rx.disposeBag)
        tableView.register(WalletHomeAssetCell.self, forCellReuseIdentifier: WalletHomeAssetCell.identifier)
        tableView.register(WalletHomeApplicationCell.self, forCellReuseIdentifier: WalletHomeApplicationCell.identifier)
        tableView.register(WalletHomeTokenCell.self, forCellReuseIdentifier: WalletHomeTokenCell.identifier)
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraint() {
        addSubview(topView)
        addSubview(tableView)
        topView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(88)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.bottom.equalTo(snp.bottomMargin)
            make.leading.trailing.equalToSuperview()
        }
    }
}

extension WalletHomeView {
    
    private func tableViewSectionedReloadDataSource() -> RxTableViewSectionedReloadDataSource<WalletSection> {
        return RxTableViewSectionedReloadDataSource(
            configureCell: { [weak self] (dataSource, tableView, indexPath, sectionItem) in
                switch sectionItem {
                case .asset(let item):
                    let cell = tableView.dequeueReusableCell(withIdentifier: WalletHomeAssetCell.identifier) as! WalletHomeAssetCell
                    if let weakself = self {
                        cell.disposeBag = DisposeBag() // 解决Cell重用导致订阅取消或者多次订阅问题
                        cell.rx.tapDetails.bind(to: weakself.detailsEvent).disposed(by: cell.disposeBag)
                    }
                    cell.walletData = item
                    return cell
                case .application(let item):
                    let cell = tableView.dequeueReusableCell(withIdentifier: WalletHomeApplicationCell.identifier) as! WalletHomeApplicationCell
                    cell.applicationDatas = item
                    return cell
                case .token(let item):
                    let cell = tableView.dequeueReusableCell(withIdentifier: WalletHomeTokenCell.identifier) as! WalletHomeTokenCell
                    cell.tokenData = item
                    return cell
                }
            }
        )
    }
}

extension WalletHomeView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSource[indexPath].itemHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch dataSource[section] {
        case .asset, .application:
            return 0
        case .token:
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch dataSource[section] {
        case .asset, .application:
            return nil
        case .token:
            return tokenHeaderView
        }
    }
}
