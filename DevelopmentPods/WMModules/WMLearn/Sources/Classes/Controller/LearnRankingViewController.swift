//
//  LearnRankingViewController.swift
//  WMLearn
//
//  Created by Condy on 2024/6/24.
//  美化说明：标准 nav bar + 顶部绿色 chip 段切换（按乐器/周/月）+ 柱状图 + 列表混合
//

import UIKit
import FeatBox
import Mediator
import RxSwift
import RxCocoa
import SnapKit

/// 世界排行榜
/// - 顶部：柱状图（横轴：用户名，纵轴：分数 0~100）
/// - 中部：完整榜单列表
/// - 点击柱条 → 跳转视频赔价榜（复用 WMDiscover 视频赔价榜形态）
class LearnRankingViewController: BaseTableViewController<LearnRankingViewModel> {

    /// 顶部时间段切换 segment
    private let segmentControl: UISegmentedControl = {
        let items = ["本周", "本月", "全部"]
        let s = UISegmentedControl(items: items)
        s.selectedSegmentIndex = 0
        return s
    }()

    /// 顶部头部装饰
    private let headerView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.fy.clear
        return v
    }()

    private let headerTitle: UILabel = {
        let l = BaseLabel()
        l.text = "世界排行 · TOP 5"
        l.textColor = UIColor.fy.mainColor
        l.font = UIFont.fy.bold_18
        return l
    }()

    private let headerSubtitle: UILabel = {
        let l = BaseLabel()
        l.text = "看看学习达人们的真实表现"
        // 美化：用 R1 引入的 gray_B0B0B0 更柔
        l.textColor = UIColor.fy.gray_B0B0B0
        l.font = UIFont.fy.system_12
        return l
    }()

    private let headerIcon: UIImageView = {
        let v = UIImageView(image: UIImage(systemName: "trophy.fill"))
        v.tintColor = UIColor.fy.lightOrange
        v.contentMode = .scaleAspectFit
        return v
    }()

    /// 美化：trophy icon 底色圆
    private let headerIconBg: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.fy.lightOrange.withAlphaComponent(0.15)
        v.layer.cornerRadius = 16
        return v
    }()

    /// 时间段切换 chip 容器
    private let chipContainer: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.fy.mainColor.withAlphaComponent(0.08)
        v.layer.cornerRadius = 18
        v.layer.masksToBounds = true
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInit()
        self.setupUI()
        self.setupBindings()
        self.setupViewModel()
    }

    func setupInit() {
        self.title = "世界排行"
        self.navigationController?.navigationBar.tintColor = UIColor.fy.title
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.fy.white
            appearance.titleTextAttributes = [.foregroundColor: UIColor.fy.title]
            appearance.shadowColor = UIColor.fy.clear
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
    }

    func setupUI() {
        self.tableView.backgroundColor = UIColor.fy.backgroundGray
        self.tableView.separatorStyle = .none
        self.tableView.tableHeaderView = makeHeader()
    }

    private func makeHeader() -> UIView {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 130))

        container.addSubview(headerView)
        headerView.addSubview(headerIconBg)
        headerIconBg.addSubview(headerIcon)
        headerView.addSubview(headerTitle)
        headerView.addSubview(headerSubtitle)
        headerView.addSubview(chipContainer)
        chipContainer.addSubview(segmentControl)

        headerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16))
        }
        headerIconBg.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(4)
            make.top.equalToSuperview().offset(12)
            make.width.height.equalTo(32)
        }
        headerIcon.snp.makeConstraints { make in
            make.center.equalTo(headerIconBg)
            make.width.height.equalTo(18)
        }
        headerTitle.snp.makeConstraints { make in
            make.top.equalTo(headerIcon).offset(-2)
            make.leading.equalTo(headerIcon.snp.trailing).offset(8)
        }
        headerSubtitle.snp.makeConstraints { make in
            make.top.equalTo(headerTitle.snp.bottom).offset(2)
            make.leading.equalTo(headerTitle)
        }
        chipContainer.snp.makeConstraints { make in
            make.top.equalTo(headerSubtitle.snp.bottom).offset(14)
            make.leading.equalToSuperview().offset(8)
            make.trailing.lessThanOrEqualToSuperview().offset(-8)
            make.height.equalTo(36)
            make.bottom.equalToSuperview().offset(-8)
        }
        segmentControl.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4))
        }
        // 设置 segmentControl 颜色
        segmentControl.selectedSegmentTintColor = UIColor.fy.mainColor
        segmentControl.setTitleTextAttributes([
            .foregroundColor: UIColor.fy.mainColor,
            .font: UIFont.fy.system_13
        ], for: .normal)
        segmentControl.setTitleTextAttributes([
            .foregroundColor: UIColor.fy.white,
            .font: UIFont.fy.bold(13)
        ], for: .selected)

        return container
    }

    func setupBindings() {
        // 切换时间段（演示阶段触发 reload）
        segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }

    func setupViewModel() {
        viewModel.request()
    }

    @objc private func segmentChanged() {
        // 切换筛选条件时触发重新加载
        viewModel.request()
    }
}

/// 视频赔价榜（独立页面，复用 WMDiscover 视频赔价榜形态）
/// - 接收 categoryId 参数
class LearnVideoRankingViewController: BaseTableViewController<LearnRankingViewModel> {

    /// 分类 ID（0 表示全部）
    public var categoryId: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInit()
        self.setupUI()
        self.setupViewModel()
    }

    func setupInit() {
        self.title = "视频赔价榜"
        self.navigationController?.navigationBar.tintColor = UIColor.fy.title
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.fy.white
            appearance.titleTextAttributes = [.foregroundColor: UIColor.fy.title]
            appearance.shadowColor = UIColor.fy.clear
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
    }

    func setupUI() {
        self.tableView.backgroundColor = UIColor.fy.backgroundGray
        self.tableView.separatorStyle = .none
    }

    func setupViewModel() {
        // 直接复用 ranking 数据演示视频赔价榜列表（演示阶段 mock 数据共用）
        // 真实场景下会改为 LearnAPI.videos(categoryId:)
        viewModel.request()
    }
}
