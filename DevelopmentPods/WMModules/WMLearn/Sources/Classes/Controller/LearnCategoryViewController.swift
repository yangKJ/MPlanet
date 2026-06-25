//
//  LearnCategoryViewController.swift
//  WMLearn
//
//  Created by Condy on 2024/6/24.
//  美化说明：标准 nav bar + 课程列表（每条 cell 卡片化）+ 顶部分类 chip 装饰
//

import UIKit
import FeatBox
import Mediator
import SnapKit

/// 分类课程列表
/// - 接收 categoryId 参数
/// - 展示该分类下的所有课程（左图 + 标题/讲师/价格 Cell）
class LearnCategoryViewController: BaseTableViewController<LearnCategoryViewModel> {

    /// 分类 ID
    public var categoryId: Int = 0

    /// 顶部头部装饰 chip
    private let headerView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.fy.mainColor.withAlphaComponent(0.08)
        v.layer.cornerRadius = 12
        // 美化：渐变层（左 8% 透明 → 右 4% 透明）
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.fy.mainColor.withAlphaComponent(0.10).cgColor,
            UIColor.fy.mainColor.withAlphaComponent(0.04).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 56)
        v.layer.insertSublayer(gradient, at: 0)
        return v
    }()

    private let headerTitle: UILabel = {
        let l = BaseLabel()
        l.text = "课程列表"
        l.textColor = UIColor.fy.mainColor
        l.font = UIFont.fy.bold_16
        return l
    }()

    private let headerSubtitle: UILabel = {
        let l = BaseLabel()
        l.text = "为你精选本分类的优质课程"
        // 美化：subtitle 颜色用 R1 引入的 gray_B0B0B0，更柔
        l.textColor = UIColor.fy.gray_B0B0B0
        l.font = UIFont.fy.system_12
        return l
    }()

    private let headerIcon: UIImageView = {
        let v = UIImageView(image: UIImage(systemName: "music.note.list"))
        v.tintColor = UIColor.fy.mainColor
        v.contentMode = .scaleAspectFit
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
        // 分类页保留系统 nav bar（左上角返回）
        self.title = "课程列表"
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
        // 顶部装饰 header
        self.tableView.tableHeaderView = makeHeader()
    }

    private func makeHeader() -> UIView {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
        container.addSubview(headerView)
        headerView.addSubview(headerIcon)
        headerView.addSubview(headerTitle)
        headerView.addSubview(headerSubtitle)

        headerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16))
        }
        headerIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
        headerTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalTo(headerIcon.snp.trailing).offset(12)
        }
        headerSubtitle.snp.makeConstraints { make in
            make.top.equalTo(headerTitle.snp.bottom).offset(4)
            make.leading.equalTo(headerTitle)
            make.trailing.equalToSuperview().offset(-16)
        }
        return container
    }

    func setupBindings() {
        // 点击课程 → 跳转课程详情
        viewModel.courseSelected
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] course in
                self?.gotoCourseDetail(courseId: course.id ?? 0)
            }).disposed(by: rx.disposeBag)
    }

    func setupViewModel() {
        viewModel.categoryId = self.categoryId
        viewModel.request()
    }

    private func gotoCourseDetail(courseId: Int) {
        if let vc = Mediator.performTarget(
            "LearnTarget",
            action: "Action_courseViewController:",
            module: "WMLearn",
            params: ["courseId": courseId]
        ) as? UIViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
