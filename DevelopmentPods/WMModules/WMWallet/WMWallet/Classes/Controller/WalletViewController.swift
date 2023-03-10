//
//  WalletViewController.swift
//  WMWallet
//
//  Created by Condy on 2020/12/28.
//

import UIKit
import FeatBox
import Rickenbacker

class WalletViewController: VMViewController<WalletViewModel> {
    
    lazy var emptyView: WalletEmptyView = {
        let view = WalletEmptyView.init(frame: .zero)
        view.isHidden = true
        return view
    }()
    
    lazy var homeView: WalletHomeView = {
        let view = WalletHomeView.init(frame: .zero)
        view.isHidden = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.setupConstraint()
        self.bindViewModel()
    }
    
    func initUI() {
        self.hbd_barHidden = true
        self.hbd_blackBarStyle = true
        self.navigationItem.leftBarButtonItem = nil
        self.view.backgroundColor = UIColor.cdy.background
    }
    
    func setupConstraint() {
        view.addSubview(emptyView)
        view.addSubview(homeView)
        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        homeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bindViewModel() {
        let input = WalletViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.displayHomeView.drive(homeView.rx.isHidden).disposed(by: disposeBag)
        output.displayEmptyView.drive(emptyView.rx.isHidden).disposed(by: disposeBag)
        output.sections.bind(to: homeView.tableView.rx.items(dataSource: homeView.dataSource)).disposed(by: disposeBag)
        
        homeView.detailsEvent.subscribe(onNext: {
            print("xxsdsd")
        }).disposed(by: disposeBag)
    }
}
