//
//  BaseTableViewController.swift
//  FeatBox
//
//  Created by Condy on 2023/4/29.
//

import Foundation
import Rickenbacker
import ProductLib

open class BaseTableViewController<T: BaseViewModel>: Rickenbacker.VMTableViewController<T>, UIScrollViewDelegate {
    
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
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 0.1))
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 0.1))
        self.registerTableViewCell().forEach { [weak self] in
            self?.tableView.fy.register($0)
        }
        self.tableView.estimatedRowHeight = 44
    }
    
    // MARK: - 子类重写实现
    
    /// 注册Cell
    open func registerTableViewCell() -> [BaseTableViewCell.Type] {
        fatalError("Subclass must override and set register table view cell class.")
    }
}

//extension TableViewAutomaticDimension {
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let height = tableViewCellHeight(tableView, indexPath: indexPath)
//        return height <= 0 ? UITableView.automaticDimension : height
//    }
//}
//    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 44
//    }
//
//    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let height = tableViewCellHeight(tableView, indexPath: indexPath)
//        return height <= 0 ? UITableView.automaticDimension : height
//    }
//
//    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableViewDidSelectRow(tableView, indexPath: indexPath)
//    }
//
//    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        tableViewHeaderHeight(tableView, section: section)
//    }
//
//    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        tableViewFooterHeight(tableView, section: section)
//    }
//
//    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        tableViewHeaderTitle(tableView, section: section)
//    }
//
//    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        tableViewFooterTitle(tableView, section: section)
//    }
//
//    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        tableViewHeaderView(tableView, section: section)
//    }
//
//    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        tableViewFooterView(tableView, section: section)
//    }
//
//    /// 设置Cell高度，返回零则动态适配高度，Cell必须制定`高度`和`顶部`和`底部`距离方可自动撑开
//    open func tableViewCellHeight(_ tableView: UITableView, indexPath: IndexPath) -> CGFloat {
//        return 0.0
//    }
//
//    /// 点击Cell
//    open func tableViewDidSelectRow(_ tableView: UITableView, indexPath: IndexPath) {
//
//    }
//
//    open func tableViewHeaderHeight(_ tableView: UITableView, section: Int) -> CGFloat {
//        return 0.0
//    }
//
//    open func tableViewFooterHeight(_ tableView: UITableView, section: Int) -> CGFloat {
//        return 0.0
//    }
//
//    open func tableViewHeaderTitle(_ tableView: UITableView, section: Int) -> String? {
//        return nil
//    }
//
//    open func tableViewFooterTitle(_ tableView: UITableView, section: Int) -> String? {
//        return nil
//    }
//
//    open func tableViewHeaderView(_ tableView: UITableView, section: Int) -> UIView? {
//        return nil
//    }
//
//    open func tableViewFooterView(_ tableView: UITableView, section: Int) -> UIView? {
//        return nil
//    }
//}
