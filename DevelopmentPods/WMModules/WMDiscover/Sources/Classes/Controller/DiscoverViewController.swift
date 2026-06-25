//
//  DiscoverViewController.swift
//  WMDiscover
//
//  Created by Condy on 2020/12/28.
//  美化：顶栏渐变绿 + 页面灰背景 + 隐藏分隔线 + section 间距 16pt
//

import UIKit
import FeatBox
import RxDataSources
import RxSwift
import RxCocoa

class DiscoverViewController: BaseTableViewController<DiscoverViewModel> {

    /// 顶部导航栏（渐变绿背景 + 粗体标题 + 右侧铃铛/消息）
    private lazy var navigationBar: DiscoverNavigationBar = {
        let bar = DiscoverNavigationBar()
        return bar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInit()
        self.setupUI()
        self.setupBindings()
        self.setupViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 修复：状态栏文字白色（绿色 nav bar 背景，iOS 13+ 用 barStyle=.black 触发）
        self.navigationController?.navigationBar.barStyle = .black
    }

    func setupInit() {
        // 隐藏自带导航栏，使用自定义绿色顶栏
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func setupUI() {
        // 修复：view 背景设成主色绿，让状态栏区域与渐变顶栏融为一体，
        // 不再透出系统白色看上去像"白色 nav"
        self.view.backgroundColor = UIColor.fy.mainColor
        // 页面灰背景
        self.tableView.backgroundColor = UIColor.fy.gray_F3F3F3
        // 隐藏系统分隔线（cell 间用 8pt 空白分隔）
        self.tableView.separatorStyle = .none
        self.tableView.separatorInset = .zero
        self.tableView.estimatedRowHeight = 0
        self.tableView.estimatedSectionFooterHeight = 0
        self.tableView.estimatedSectionHeaderHeight = 0

        // 注入自定义导航栏到 view（延伸到状态栏）
        self.view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(DiscoverNavigationBarMetrics.contentHeight)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 修复：viewDidLoad 时 safeAreaInsets.top 为 0，导航栏延伸到状态栏需要在这里动态修正
        let safeAreaTop = self.view.safeAreaInsets.top
        let totalNavHeight = safeAreaTop + DiscoverNavigationBarMetrics.contentHeight
        navigationBar.snp.updateConstraints { make in
            make.height.equalTo(totalNavHeight)
        }
        // 内容区向下偏移导航栏高度
        self.tableView.contentInset = UIEdgeInsets(top: totalNavHeight, left: 0, bottom: 24, right: 0)
        self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: safeAreaTop, left: 0, bottom: 0, right: 0)
        // 重设初始偏移，让内容不被导航栏遮挡
        if self.tableView.contentOffset.y == 0 || self.tableView.contentOffset.y == -(totalNavHeight - safeAreaTop) {
            self.tableView.contentOffset = CGPoint(x: 0, y: -totalNavHeight)
        }
    }

    func setupBindings() {
        // 铃铛：暂时 stub
        navigationBar.bellTap.subscribe(onNext: { _ in
            print("[Discover] bell tapped")
        }).disposed(by: rx.disposeBag)

        // 消息：暂时 stub
        navigationBar.messageTap.subscribe(onNext: { _ in
            print("[Discover] message tapped")
        }).disposed(by: rx.disposeBag)
    }

    func setupViewModel() {
        viewModel.request()
    }
}
