//
//  MineSettingViewController.swift
//  WMMine
//
//  Created by Condy on 2023/6/6.
//

import Foundation
import SnapKit
import FeatBox
import RxCocoa

class MineSettingViewController: BaseTableViewController<MineSettingViewModel> {
    
    public var users: MineUsers? {
        didSet {
            guard let users = users else {
                return
            }
            if let imagePath = users.avatar_url {
                let size = CGSize(width: Ces.width, height: Self.imageViewHeight)
                self.imageView.fy.setImage(with: imagePath)
            }
        }
    }
    
    static let imageViewHeight: CGFloat = 150
    static let rowHeight: CGFloat = 50
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: Ces.width, height: Self.imageViewHeight))
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInit()
        self.setupUI()
        self.setupViewModel()
        self.setupBindings()
    }
    
    override func registerTableViewCell() -> [BaseTableViewCell.Type] {
        return [
            MineFunctionFormCell.self
        ]
    }
    
    func setupInit() {
        self.title = Res.text("设置中心")
    }
    
    func setupUI() {
        tableView.rowHeight = Self.rowHeight
        tableView.estimatedRowHeight = imageView.frame.size.height
        tableView.tableHeaderView = imageView
    }
    
    func setupViewModel() {
        // 绑定功能列表数据
        viewModel.outputs.mineFunctions.bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.fy.dequeueReusableCell(MineFunctionFormCell.self)
            cell.functionForm.accept(element)
            return cell
        }.disposed(by: rx.disposeBag)
        
        self.viewModel.inputs.setupFunctionForm(with: self.users)
    }
    
    func setupBindings() {
        // 点击事件
        tableView.rx.modelSelected(MineFunctionForm.self).subscribe(onNext: { [weak self] (element) in
            guard let vc = element.gotoViewController(with: self?.users) else {
                return
            }
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: rx.disposeBag)
    }
}
