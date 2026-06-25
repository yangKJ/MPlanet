//
//  WalletViewController.swift
//  WMWallet
//
//  Created by Condy on 2024/6/24.
//  美化：渐变绿顶栏(safeAreaTop + 44) + 白卡资产 + Discover 风格功能列表
//

import UIKit
import FeatBox
import SnapKit

/// 钱包/会员页面
/// 模拟已登录高权限用户展示的动态 Tab 页面
class WalletViewController: BaseViewController<BaseViewModel> {

    /// 顶部导航栏内容区高度（与 DiscoverNavigationBarMetrics 保持一致）
    private let navContentHeight: CGFloat = 44

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.alwaysBounceVertical = true
        return sv
    }()

    private let contentView = UIView()

    // 顶部渐变背景容器（与 DiscoverNavigationBar 视觉一致）
    private let topBackgroundView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.fy.clear
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

    private let navTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "钱包"
        lb.textColor = UIColor.fy.white
        lb.font = UIFont.fy.bold_18
        lb.textAlignment = .center
        return lb
    }()

    // 余额卡片（Discover 风格：白卡 + 圆角 12 + 柔和阴影）
    private let balanceCard: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.fy.white
        v.layer.cornerRadius = 12
        v.layer.masksToBounds = false
        v.layer.shadowColor = UIColor.fy.black.cgColor
        v.layer.shadowOpacity = 0.06
        v.layer.shadowOffset = CGSize(width: 0, height: 2)
        v.layer.shadowRadius = 6
        return v
    }()

    private let balanceTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "账户余额（元）"
        lb.font = UIFont.fy.system_12
        lb.textColor = UIColor.fy.itemSubTitle
        return lb
    }()

    private let balanceNumberLabel: UILabel = {
        let lb = UILabel()
        lb.text = "¥ 1,280.00"
        // token 上限是 bold_20，禁止硬编码更大字号的字面量
        lb.font = UIFont.fy.bold_20
        lb.textColor = UIColor.fy.title
        // 美化：轻投影让数字更立体
        lb.layer.shadowColor = UIColor.fy.black.cgColor
        lb.layer.shadowOpacity = 0.05
        lb.layer.shadowOffset = CGSize(width: 0, height: 1)
        lb.layer.shadowRadius = 1
        return lb
    }()

    private let rechargeButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("立即充值", for: .normal)
        bt.setTitleColor(UIColor.fy.white, for: .normal)
        bt.titleLabel?.font = UIFont.fy.bold_14
        bt.backgroundColor = UIColor.fy.mainColor
        bt.layer.cornerRadius = 16
        return bt
    }()

    private let withdrawButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("提现", for: .normal)
        bt.setTitleColor(UIColor.fy.mainColor, for: .normal)
        bt.titleLabel?.font = UIFont.fy.bold_14
        bt.backgroundColor = UIColor.fy.mainColor.withAlphaComponent(0.12)
        bt.layer.cornerRadius = 16
        return bt
    }()

    // 功能列表白卡容器（参考 DiscoverPostCell.cardView 的卡片化手法）
    private let menuCard: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.fy.white
        v.layer.cornerRadius = 12
        v.layer.masksToBounds = true
        return v
    }()

    private let menuStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 0
        sv.alignment = .fill
        sv.distribution = .fill
        return sv
    }()

    private let menuItems: [(icon: String, title: String)] = [
        ("creditcard", "我的优惠券"),
        ("gift", "邀请好友"),
        ("clock.arrow.circlepath", "消费记录"),
        ("gearshape", "会员设置"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        // 状态栏白字（绿色渐变背景）
        navigationController?.navigationBar.barStyle = .black
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func setupUI() {
        view.backgroundColor = UIColor.fy.gray_F3F3F3

        // 渐变层放最底层
        topBackgroundView.layer.insertSublayer(gradientLayer, at: 0)
        topBackgroundView.addSubview(navTitleLabel)

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(topBackgroundView)
        contentView.addSubview(balanceCard)
        balanceCard.addSubview(balanceTitleLabel)
        balanceCard.addSubview(balanceNumberLabel)
        balanceCard.addSubview(rechargeButton)
        balanceCard.addSubview(withdrawButton)
        contentView.addSubview(menuCard)
        menuCard.addSubview(menuStackView)

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view)
        }
        topBackgroundView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            // 顶栏高度由 viewDidLayoutSubviews 动态计算（safeAreaTop + navContentHeight）
        }
        navTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            // 文字底部到顶栏底部 10pt，参考 DiscoverNavigationBar.titleLabel
            make.bottom.equalToSuperview().offset(-10)
        }
        balanceCard.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            // 资产卡片上移到顶栏内部下沿，呈现"卡片半叠在渐变背景上"效果
            make.top.equalTo(topBackgroundView.snp.bottom).offset(-36)
            // 不写死 height，让内容撑开
        }
        balanceTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        balanceNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(balanceTitleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        withdrawButton.snp.makeConstraints { make in
            make.top.equalTo(balanceNumberLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(32)
            make.width.equalTo(72)
            make.bottom.equalToSuperview().offset(-20)
        }
        rechargeButton.snp.makeConstraints { make in
            make.centerY.equalTo(withdrawButton)
            make.leading.equalTo(withdrawButton.snp.trailing).offset(12)
            make.height.equalTo(32)
            make.width.equalTo(72)
        }
        menuCard.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.top.equalTo(balanceCard.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(-40)
        }
        menuStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // 填充菜单项
        for (index, item) in menuItems.enumerated() {
            let row = makeMenuRow(icon: item.icon, title: item.title)
            menuStackView.addArrangedSubview(row)
            row.snp.makeConstraints { make in
                make.height.equalTo(52)
            }
            // 行间分隔线（除最后一行外）
            if index < menuItems.count - 1 {
                let line = UIView()
                line.backgroundColor = UIColor.fy.line
                menuCard.addSubview(line)
                line.snp.makeConstraints { make in
                    make.leading.equalToSuperview().offset(16)
                    make.trailing.equalToSuperview()
                    make.top.equalTo(row.snp.bottom)
                    make.height.equalTo(CGFloat.fy.px1)
                }
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 修复：viewDidLoad 时 safeAreaInsets.top 为 0，顶栏需要动态计算真实高度
        let safeAreaTop = view.safeAreaInsets.top
        let totalNavHeight = safeAreaTop + navContentHeight
        // 修复 baseline 崩溃：原来用 updateConstraints，但 setupUI 第一次没建 height 约束，
        // update 找不到目标就会断言崩溃（SnapKit Constraint.swift:320）。
        // 改用 remakeConstraints：无则建，有则改，幂等安全。
        topBackgroundView.snp.remakeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(totalNavHeight)
        }
        gradientLayer.frame = topBackgroundView.bounds
    }

    private func makeMenuRow(icon: String, title: String) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor.fy.white

        // 主色小色块底（参考 DiscoverQuickEntriesCell.iconBg 手法）
        let iconBg = UIView()
        iconBg.backgroundColor = UIColor.fy.mainColor.withAlphaComponent(0.12)
        iconBg.layer.cornerRadius = 14
        iconBg.isUserInteractionEnabled = false

        let iconView = UIImageView()
        iconView.image = UIImage(systemName: icon)
        iconView.tintColor = UIColor.fy.mainColor
        iconView.contentMode = .scaleAspectFit
        iconView.isUserInteractionEnabled = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.fy.system_15
        titleLabel.textColor = UIColor.fy.title

        let arrow = UIImageView()
        arrow.image = UIImage(systemName: "chevron.right")
        arrow.tintColor = UIColor.fy.itemSubTitle
        arrow.contentMode = .scaleAspectFit

        container.addSubview(iconBg)
        iconBg.addSubview(iconView)
        container.addSubview(titleLabel)
        container.addSubview(arrow)

        iconBg.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(28)
        }
        iconView.snp.makeConstraints { make in
            make.center.equalTo(iconBg)
            make.width.height.equalTo(18)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconBg.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualTo(arrow.snp.leading).offset(-12)
        }
        arrow.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(14)
        }

        return container
    }
}