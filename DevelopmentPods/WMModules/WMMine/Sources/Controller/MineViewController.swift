//
//  MineViewController.swift
//  WMMine
//
//  Created by Condy on 2020/12/28.
//

import UIKit
import SnapKit
import Rickenbacker

class MineViewController: VMTableViewController<MineViewModel> {

    private static let identifier = "MineCellIdentifier"
    
    lazy var resetBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem.init(title: "Reset", style: .plain, target: nil, action: nil)
        if let header = tableView.mj_header {
            barButton.rx.tap.bind(to: header.rx.beginRefreshing).disposed(by: disposeBag)
        }
        return barButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInit()
        self.setupUI()
        self.setupBindings()
    }
    
    func setupInit() {
        self.hbd_barShadowHidden = true
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = self.resetBarButton
    }
    
    func setupUI() {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.view.snp.bottomMargin)
            make.left.right.equalToSuperview()
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: MineViewController.identifier)
    }
    
    func setupBindings() {
        tableView.rx.modelSelected(String.self).subscribe (onNext: { (element) in
            
        }).disposed(by: disposeBag)
        
        viewModel.outputs.dataSource.bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: MineViewController.identifier)!
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.textColor = UIColor.blue
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.textLabel?.text = "\(row + 1). " + element
            return cell
        }
        .disposed(by: disposeBag)
        
        viewModel.isEmptyData.subscribe { (empty) in
            
        }.disposed(by: disposeBag)
        
        self.emptyDataSetViewTap.subscribe { [weak self] _ in
            self?.viewModel.loadData()
        }.disposed(by: disposeBag)
        
        headerRefreshing.subscribe { [weak self] _ in
            self?.viewModel.loadData()
        }.disposed(by: disposeBag)
    }
}

extension MineViewController: DZNEmptyDataSetable {
    
    func DZNEmptyDataSetImage(scrollView: UIScrollView) -> UIImage {
        R.image("base_network_error_black", forResource: "Rickenbacker")
    }
    
    func DZNEmptyDataSetImageTintColor(scrollView: UIScrollView) -> UIColor? {
        return UIColor.red
    }
}
