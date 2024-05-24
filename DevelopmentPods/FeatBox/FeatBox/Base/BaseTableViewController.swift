//
//  BaseTableViewController.swift
//  FeatBox
//
//  Created by Condy on 2023/4/29.
//

import Foundation
import Rickenbacker
import ProductLib
import UITableView_FDTemplateLayoutCell

open class BaseTableViewController<T: BaseViewModel>: VMTableViewController<T>, UIScrollViewDelegate, UITableViewDelegate {
    
    public convenience init(_ style: UITableView.Style = .plain) {
        self.init(style: style, viewModel: T.init())
    }
    
    public convenience init(style: UITableView.Style = .plain, viewModel: T) {
        let table = BaseTableView.init(frame: .zero, style: style)
        //table.rowHeight = UITableView.automaticDimension
        //table.estimatedRowHeight = 44
        //table.sectionHeaderHeight = 0.00001
        //table.sectionFooterHeight = 0.00001
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        table.cellLayoutMarginsFollowReadableWidth = false
        table.tableFooterView = UIView()
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        table.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        if #available(iOS 11, *) {
            table.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        if #available(iOS 15.0, *) {
            table.sectionHeaderTopPadding = 0
        }
        self.init(tableView: table, viewModel: viewModel)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews__()
    }
    
    private func setupViews__() {
        self.view.backgroundColor = UIColor.fy.background
        self.tableView.backgroundColor = UIColor.fy.background
        self.tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        if self is NavigationBarHiddenable {
            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        self.tableView.separatorStyle = .none
        self.tableView.sectionIndexBackgroundColor = UIColor.fy.clear
        self.tableView.sectionIndexColor = UIColor.fy.gray_999999
        //self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 0.1))
        //self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 0.1))
        self.registerTableViewCell().forEach { [weak self] in
            self?.tableView.fy.register($0)
        }
        self.tableView.estimatedRowHeight = 44
        //self.tableView.rowHeight = UITableView.automaticDimension
        if tableView.style == .grouped && tableView.tableHeaderView == nil {
            let header = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 0.1))
            tableView.tableHeaderView = header
        }
    }
    
    // MARK: - 子类重写实现
    
    /// 注册Cell
    open func registerTableViewCell() -> [BaseTableViewCell.Type] {
        fatalError("Subclass must override and set register table view cell class.")
    }
    
    /// 配置Cell高度
    open func tableViewCellHeight(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        /// 返回`UITableView.automaticDimension`则动态适配高度，Cell必须制定`高度`和`顶部`和`底部`距离方可自动撑开
        return UITableView.automaticDimension
    }
    
    /// 配置Header高度
    open func tableViewHeaderHeight(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // 使用后者`UITableView.automaticDimension`会出现白色Header导致布局尺寸变宽的问题
        return 0.1//UITableView.automaticDimension
    }
    
    /// 配置HeaderView
    open func tableViewHeaderView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    /// 配置Footer高度
    open func tableViewFooterHeight(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1//UITableView.automaticDimension
    }
    
    /// 配置FooterView
    open func tableViewFooterView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    // MARK: - UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewCellHeight(tableView, heightForRowAt: indexPath)
//        let customizedHeight = tableViewCellHeight(tableView, heightForRowAt: indexPath)
//        switch customizedHeight {
//        case UITableView.automaticDimension, ...0.0:
//            guard let cell = tableView.cellForRow(at: indexPath) as? BaseTableViewCell else {
//                return customizedHeight
//            }
//            // https://blog.sunnyxx.com/2015/05/17/cell-height-calculation/
//            let cacheHeight = tableView.fd_heightForCell(withIdentifier: cell.fy.identifier, configuration: nil)
//            return cacheHeight == 0.0 ? 0.00002 : cacheHeight
//        default:
//            return customizedHeight
//        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        tableViewHeaderHeight(tableView, heightForHeaderInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableViewHeaderView(tableView, viewForHeaderInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        tableViewFooterHeight(tableView, heightForFooterInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        tableViewFooterView(tableView, viewForFooterInSection: section)
    }
}
