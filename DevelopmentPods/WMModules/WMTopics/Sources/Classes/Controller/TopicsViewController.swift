//
//  TopicsViewController.swift
//  WMTopics
//
//  Created by Condy on 2024/5/24.
//  主题 Tab 控制器：绿色导航栏 + 3 tab 切换 + 帖子流
//

import UIKit
import FeatBox
import RxSwift
import RxCocoa
import Mediator

/// 主题 Tab 主页
/// - 顶部：绿色背景 + 「主题」标题 + 3 tab 切换（最新/热门/我的关注）
/// - 帖子流：用户头像 + 内容 + 点赞/评论/分享
class TopicsViewController: BaseTableViewController<TopicsViewModel> {

    /// 顶部 3 tab 切换控件
    private lazy var segmentedBar: TopicsSegmentedControl = {
        let bar = TopicsSegmentedControl()
        return bar
    }()

    /// 顶部绿色顶栏内容区高度
    // 美化：48 → 52，让 segmented control 上下各多 2pt 呼吸
    private let navigationBarContentHeight: CGFloat = 52

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
        // 修复：view 背景设成主色绿，让状态栏区域与 segmented 融为一体，
        // 不再透出系统白色看上去像"白色 nav"
        self.view.backgroundColor = UIColor.fy.mainColor
        // 页面灰背景，对齐 Discover 风格
        self.tableView.backgroundColor = UIColor.fy.gray_F3F3F3
        // 隐藏系统分隔线（cell 间用 section 空白分隔）
        self.tableView.separatorStyle = .none
        self.tableView.separatorInset = .zero
        self.tableView.estimatedRowHeight = 0
        self.tableView.estimatedSectionFooterHeight = 0
        self.tableView.estimatedSectionHeaderHeight = 0

        // 自定义绿色顶栏：包含 3 tab 切换，延伸到状态栏
        self.view.addSubview(segmentedBar)
        segmentedBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(navigationBarContentHeight)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 修复：viewDidLoad 时 safeAreaInsets.top 为 0，导航栏延伸到状态栏需要在这里动态修正
        let safeAreaTop = self.view.safeAreaInsets.top
        let totalNavHeight = safeAreaTop + navigationBarContentHeight
        segmentedBar.snp.updateConstraints { make in
            make.height.equalTo(totalNavHeight)
        }
        // 把状态栏安全区传给 segmented 控件，让 segmented 顶部从状态栏下方开始
        segmentedBar.updateSafeAreaInset(safeAreaTop)
        // 内容区向下偏移导航栏高度
        self.tableView.contentInset = UIEdgeInsets(top: totalNavHeight, left: 0, bottom: 0, right: 0)
        self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: totalNavHeight, left: 0, bottom: 0, right: 0)
        // 重设初始偏移，让内容不被导航栏遮挡
        if self.tableView.contentOffset.y == 0 {
            self.tableView.contentOffset = CGPoint(x: 0, y: -totalNavHeight)
        }
    }

    func setupBindings() {
        // 切换 tab → 重新请求对应 type 的数据
        segmentedBar.typeSelected
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] type in
                self?.viewModel.request(type: type)
            }).disposed(by: rx.disposeBag)

        // 点击 cell → 跳转到帖子详情
        viewModel.topicSelected
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] topic in
                self?.gotoTopicDetail(topicId: topic.id ?? 0)
            }).disposed(by: rx.disposeBag)
    }

    func setupViewModel() {
        // 默认请求最新
        viewModel.request(type: "latest")
    }

    private func gotoTopicDetail(topicId: Int) {
        if let vc = Mediator.performTarget(
            "TopicsTarget",
            action: "Action_detailViewController:",
            module: "WMTopics",
            params: ["id": topicId]
        ) as? UIViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
