//
//  LearnCourseViewController.swift
//  WMLearn
//
//  Created by Condy on 2024/6/24.
//  美化说明：透明 nav bar + 渐变绿色大标题 + 卡片化 sections（视频/介绍/章节）
//

import UIKit
import FeatBox
import RxCocoa
import SnapKit

/// 课程详情页
/// - 接收 courseId 参数
/// - 顶部：视频封面 + 课程标题 + 价格 + 讲师信息 + 介绍
/// - 章节：章节目录列表
class LearnCourseViewController: BaseTableViewController<LearnCourseViewModel> {

    /// 课程 ID
    public var courseId: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInit()
        self.setupUI()
        self.setupBindings()
        self.setupViewModel()
    }

    func setupInit() {
        // 课程详情使用标准 nav bar
        self.title = "课程详情"
        self.navigationController?.navigationBar.tintColor = UIColor.fy.title
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.fy.white
            // 美化：标题用 bold_18 更显眼
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor.fy.title,
                .font: UIFont.fy.bold_18
            ]
            appearance.shadowColor = UIColor.fy.gray_F3F3F3
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
    }

    func setupUI() {
        self.tableView.backgroundColor = UIColor.fy.backgroundGray
        // 章节 section 使用白色卡片背景
        self.tableView.separatorStyle = .none
    }

    func setupBindings() {
        // 课程加载完成后更新导航栏标题
        viewModel.course
            .compactMap { $0?.title }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] title in
                self?.title = title
            }).disposed(by: rx.disposeBag)
    }

    func setupViewModel() {
        viewModel.courseId = self.courseId
        viewModel.request()
    }
}
