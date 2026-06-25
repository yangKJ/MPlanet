//
//  BannerDetailViewController.swift
//  WMDiscover
//
//  Created by Condy on 2023/5/29.
//

import Foundation
import FeatBox
import RxDataSources

class BannerDetailViewController: BaseTableViewController<BannerDetailViewModel> {
    
    public var index: Int = 0
    public var list: [Banner] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInit()
        self.setupUI()
        self.setupViewModel()
    }

    func setupInit() {
        self.title = self.list[safe: self.index]?.title
    }

    // MARK: - 美化
    private func setupUI() {
        // 页面灰背景（与 DiscoverVC 一致）
        self.tableView.backgroundColor = UIColor.fy.gray_F3F3F3
        // 隐藏系统分隔线，cell 间用 8pt 留白分隔
        self.tableView.separatorStyle = .none
        self.tableView.separatorInset = .zero
        self.tableView.estimatedRowHeight = 0
        self.tableView.estimatedSectionFooterHeight = 0
        self.tableView.estimatedSectionHeaderHeight = 0
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 美化：透明 nav bar + 大标题样式（黑色导航栏）
        self.navigationController?.navigationBar.barStyle = .black
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.fy.bold_18
        ]
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 恢复系统默认外观，避免污染其他页面
        self.navigationController?.navigationBar.standardAppearance = UINavigationBarAppearance()
        self.navigationController?.navigationBar.scrollEdgeAppearance = nil
    }
    
    func setupViewModel() {
        // 列表滚动监听
        viewModel.currentIndex.distinctUntilChanged()
            .subscribe(onNext: { [weak self] in
                print("index: - \($0)")
                self?.index = $0
                self?.viewModel.requestBannerDetail(with: $0, banners: self?.list)
            }).disposed(by: rx.disposeBag)
        
        // 监听卡列表变化
        viewModel.banners.subscribe(onNext: { [weak self] in
            self?.list = $0
        }).disposed(by: rx.disposeBag)
        
        // 卡详情数据
        viewModel.detailTitle.bind(to: self.rx.title).disposed(by: rx.disposeBag)
        
        //viewModel.outputs.isEmptyData.bind(to: tableView.rx.isHidden).disposed(by: rx.disposeBag)
        
        // 驱动网络请求
        viewModel.requestBannerDetail(with: self.index, banners: self.list)
    }
}
