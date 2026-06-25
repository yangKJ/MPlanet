//
//  DiscoverNavigationBar.swift
//  WMDiscover
//
//  Created by UI Designer on 2024/5/24.
//  Home Tab 顶部导航栏：渐变绿背景 + 「寻音星球」粗体标题 + 圆形描边按钮
//

import UIKit
import RxSwift
import RxCocoa
import FeatBox
import SnapKit

/// 导航栏高度常量
/// 修复：原代码硬编码 totalHeight = 44 + 20，假设状态栏 20pt。
/// 但 iPhone 14 Pro+ 状态栏是 47pt（Dynamic Island），iPhone 15/16 Pro 是 59pt。
/// 硬编码 20pt 在新设备上顶部会"被遮挡一大截"（状态栏区显示系统灰色，nav bar 矮，灰色空白区）。
/// 现在 nav bar 延伸到状态栏（frame = 0..screenWidth, 0..safeAreaTop+44），
/// 不再用固定数字，contentInset 由调用方传入 safeAreaTop 动态计算。
enum DiscoverNavigationBarMetrics {
    /// 内容区域（不含状态栏）高度
    static let contentHeight: CGFloat = 44
}

/// 顶部导航栏
/// 用法：作为 tableHeaderView，contentInset 调整。
class DiscoverNavigationBar: UIView {

    /// 铃铛点击
    let bellTap = PublishRelay<Void>()
    /// 消息点击
    let messageTap = PublishRelay<Void>()

    /// 渐变背景层
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

    /// 底部 1px 阴影分隔
    private let bottomShadow: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.fy.clear
        v.layer.shadowColor = UIColor.fy.black.cgColor
        v.layer.shadowOpacity = 0.06
        v.layer.shadowOffset = CGSize(width: 0, height: 2)
        v.layer.shadowRadius = 4
        return v
    }()

    private let titleLabel: BaseLabel = {
        let l = BaseLabel()
        l.text = "寻音星球"
        l.textColor = UIColor.fy.white
        l.font = UIFont.fy.bold_18
        l.textAlignment = .center
        return l
    }()

    private let bellButton: UIButton = {
        let b = UIButton(type: .system)
        b.tintColor = UIColor.fy.white
        b.setImage(UIImage(systemName: "bell.fill"), for: .normal)
        b.imageView?.contentMode = .scaleAspectFit
        b.layer.borderWidth = CGFloat.fy.px1
        b.layer.borderColor = UIColor.fy.white.withAlphaComponent(0.6).cgColor
        b.layer.cornerRadius = 16
        b.layer.masksToBounds = true
        return b
    }()

    private let messageButton: UIButton = {
        let b = UIButton(type: .system)
        b.tintColor = UIColor.fy.white
        b.setImage(UIImage(systemName: "envelope.fill"), for: .normal)
        b.imageView?.contentMode = .scaleAspectFit
        b.layer.borderWidth = CGFloat.fy.px1
        b.layer.borderColor = UIColor.fy.white.withAlphaComponent(0.6).cgColor
        b.layer.cornerRadius = 16
        b.layer.masksToBounds = true
        return b
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
        self.setupBindings()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupViews()
        self.setupBindings()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // 让渐变跟随视图真实尺寸
        gradientLayer.frame = bounds
    }

    private func setupViews() {
        // 渐变 layer 放底层（不能放 layer 顺序第一位会被覆盖，直接放 backgroundView）
        let bg = UIView()
        bg.backgroundColor = UIColor.fy.clear
        bg.layer.insertSublayer(gradientLayer, at: 0)
        self.addSubview(bg)
        self.addSubview(bottomShadow)

        bg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bottomShadow.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(4)
        }

        bg.addSubview(titleLabel)
        bg.addSubview(bellButton)
        bg.addSubview(messageButton)

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
        messageButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-8)
            make.width.height.equalTo(32)
        }
        bellButton.snp.makeConstraints { make in
            make.right.equalTo(messageButton.snp.left).offset(-8)
            make.bottom.equalToSuperview().offset(-8)
            make.width.height.equalTo(32)
        }

        // 缩小 SF Symbol 边距使圆形按钮更精致
        bellButton.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        messageButton.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
    }

    private func setupBindings() {
        bellButton.rx.tap
            .bind(to: bellTap)
            .disposed(by: rx.disposeBag)
        messageButton.rx.tap
            .bind(to: messageTap)
            .disposed(by: rx.disposeBag)
    }
}
