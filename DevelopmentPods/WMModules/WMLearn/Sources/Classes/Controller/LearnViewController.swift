//
//  LearnViewController.swift
//  WMLearn
//
//  Created by Condy on 2024/6/24.
//  美化说明：顶部绿色 nav bar（渐变）+ 白色加粗标题 + 圆形描边按钮 + 卡片化 section 间距
//

import UIKit
import FeatBox
import Mediator
import RxCocoa
import SnapKit

/// 学习区首页
/// - 顶部：绿色渐变导航栏 + 「学习」标题 + 右侧搜索 + 左侧排行榜按钮
/// - Section 1：6 大分类宫格（白卡 + 圆角 icon + 进度条）
/// - Section 2：视频赔价榜入口（白卡 + 横向视频卡）
class LearnViewController: BaseTableViewController<LearnViewModel> {

    /// 自定义顶部导航栏（渐变绿）
    private let navigationBar: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.fy.mainColor
        return v
    }()

    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.fy.mainColor.cgColor,
            UIColor.fy.mainColor.withAlphaComponent(0.85).cgColor
        ]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        return layer
    }()

    private let titleLabel: UILabel = {
        let l = BaseLabel()
        l.text = "学习"
        l.textColor = UIColor.fy.white
        l.font = UIFont.fy.bold_18
        l.textAlignment = .center
        return l
    }()

    private let searchButton: UIButton = {
        let b = UIButton(type: .system)
        b.tintColor = UIColor.fy.white
        b.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        b.imageView?.contentMode = .scaleAspectFit
        b.layer.borderWidth = CGFloat.fy.px1
        b.layer.borderColor = UIColor.fy.white.withAlphaComponent(0.6).cgColor
        // 美化：圆角 16 → 17 更圆，与右侧 ranking 对齐
        b.layer.cornerRadius = 17
        b.layer.masksToBounds = true
        return b
    }()

    private let rankingButton: UIButton = {
        let b = UIButton(type: .system)
        b.tintColor = UIColor.fy.white
        b.setImage(UIImage(systemName: "chart.bar.fill"), for: .normal)
        b.imageView?.contentMode = .scaleAspectFit
        b.layer.borderWidth = CGFloat.fy.px1
        b.layer.borderColor = UIColor.fy.white.withAlphaComponent(0.6).cgColor
        b.layer.cornerRadius = 17
        b.layer.masksToBounds = true
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInit()
        self.setupUI()
        self.setupBindings()
        self.setupViewModel()
    }

    func setupInit() {
        // 隐藏自带 navigationBar（用自定义渐变顶栏）
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        // 添加自定义渐变顶栏
        self.view.addSubview(navigationBar)
        navigationBar.layer.insertSublayer(gradientLayer, at: 0)
        navigationBar.addSubview(titleLabel)
        navigationBar.addSubview(searchButton)
        navigationBar.addSubview(rankingButton)

        navigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }
        rankingButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-6)
            make.width.height.equalTo(32)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
        searchButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-6)
            make.width.height.equalTo(32)
        }
        searchButton.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        rankingButton.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
    }

    func setupUI() {
        // 修复：view 背景设成主色绿，让状态栏区域与渐变顶栏融为一体，
        // 不再透出系统白色看上去像"白色 nav"
        self.view.backgroundColor = UIColor.fy.mainColor
        // 页面背景灰色
        self.tableView.backgroundColor = UIColor.fy.backgroundGray
        // 顶部 contentInset 由 viewDidLayoutSubviews() 根据 safeAreaInsets 动态设置，
        // 因为 viewDidLoad 时 safeAreaInsets.top 仍为 0，此处不能写死。
    }

    func setupBindings() {
        searchButton.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
        rankingButton.addTarget(self, action: #selector(rankingAction), for: .touchUpInside)
    }

    func setupViewModel() {
        viewModel.request()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 渐变层填满
        gradientLayer.frame = navigationBar.bounds
        // 内容区向下偏移导航栏高度（safeAreaTop + 44 与 setupInit 中的约束保持一致）
        // 与 Discover/Topics 相同处理：必须在这里动态计算，因为 viewDidLoad 时 safeAreaInsets.top 仍为 0。
        let safeAreaTop = self.view.safeAreaInsets.top
        let totalNavHeight = safeAreaTop + 44
        self.tableView.contentInset = UIEdgeInsets(top: totalNavHeight, left: 0, bottom: 0, right: 0)
        self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: safeAreaTop, left: 0, bottom: 0, right: 0)
        // 重设初始偏移，让内容不被导航栏遮挡
        if self.tableView.contentOffset.y == 0 || self.tableView.contentOffset.y == -(totalNavHeight - safeAreaTop) {
            self.tableView.contentOffset = CGPoint(x: 0, y: -totalNavHeight)
        }
    }

    @objc private func searchAction() {
        // 搜索入口（演示用，后续可扩展为搜索页面）
        print("学习区搜索")
    }

    @objc private func rankingAction() {
        // 跳转世界排行榜
        if let vc = Mediator.performTarget(
            "LearnTarget",
            action: "Action_rankingViewController",
            module: "WMLearn"
        ) as? UIViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
