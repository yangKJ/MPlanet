//
//  BaseTableViewController.swift
//  FeatBox
//
//  Created by Condy on 2023/4/29.
//

import Foundation
import Rickenbacker
import ProductLib

open class BaseTableViewController<T: BaseTableViewModel>: VMTableViewController<T> {
    
    public convenience init(_ style: UITableView.Style = .plain) {
        self.init(style: style, viewModel: T.init())
    }
    
    public convenience init(style: UITableView.Style = .plain, viewModel: T) {
        let table = Self.createTableView(BaseTableView.self, style: style)
        self.init(tableView: table, viewModel: viewModel)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        // 美化：页面默认背景 backgroundGray F3F3F3，与 6 个业务模块对齐
        self.view.backgroundColor = UIColor.fy.gray_F3F3F3
        self.viewModel.tableView = tableView as? BaseTableView
        self.tableView.backgroundColor = UIColor.fy.gray_F3F3F3
        self.tableView.sectionIndexBackgroundColor = UIColor.fy.clear
        // 美化：section index 颜色用 R1 引入的 gray_B0B0B0 更柔
        self.tableView.sectionIndexColor = UIColor.fy.gray_B0B0B0
        self.tableView.delegate = self.viewModel
        self.tableView.dataSource = self.viewModel
    }
    
    // MARK: - 子类重写实现

    /// 设置无数据空白图像
    open func setupDZNEmptyDataSetImage(scrollView: UIScrollView) -> UIImage {
        Res.base_network_error_black ?? UIImage()
    }

    open func setupDZNEmptyDataSetImageTintColor(scrollView: UIScrollView) -> UIColor? {
        // 美化：默认 tint 用主色绿 30% 透明,视觉更柔和
        UIColor.fy.mainColor.withAlphaComponent(0.30)
    }
}

extension BaseTableViewController: DZNEmptyDataSetable {
    
    public func DZNEmptyDataSetImage(scrollView: UIScrollView) -> UIImage {
        setupDZNEmptyDataSetImage(scrollView: scrollView)
    }
    
    public func DZNEmptyDataSetImageTintColor(scrollView: UIScrollView) -> UIColor? {
        setupDZNEmptyDataSetImageTintColor(scrollView: scrollView)
    }
}
