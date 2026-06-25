//
//  ChatListViewController.swift
//  WMChat
//
//  Created by Condy on 2024/5/24.
//  消息 Tab 控制器：绿色导航栏 + 会话列表
//

import UIKit
import FeatBox
import RxSwift
import RxCocoa

/// 消息 Tab 主页
/// - 顶部：绿色背景 + 「消息」标题
/// - 会话列表：头像 + 用户名 + 最后消息 + 未读红点 + 时间
class ChatListViewController: BaseTableViewController<ChatListViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInit()
        self.setupUI()
        self.setupBindings()
        self.setupViewModel()
    }

    func setupInit() {
        self.navigationTitle = "消息"
        self.navigationItem.leftBarButtonItem = nil
        // 美化：导航栏绿色渐变（从 mainColor 到 mainColor 0.85）+ 底部 4pt 阴影
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            // 用渐变图片实现
            let gradient = CAGradientLayer()
            gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 96)
            gradient.colors = [
                UIColor.fy.mainColor.cgColor,
                UIColor.fy.mainColor.withAlphaComponent(0.85).cgColor
            ]
            gradient.startPoint = CGPoint(x: 0.5, y: 0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1)
            UIGraphicsBeginImageContextWithOptions(gradient.frame.size, false, 0)
            gradient.render(in: UIGraphicsGetCurrentContext()!)
            let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            appearance.backgroundImage = gradientImage
            // 美化：标题 bold_18 与 wallet/Discover 视觉语言统一
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor.fy.white,
                .font: UIFont.fy.bold_18
            ]
            appearance.shadowColor = .clear
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        self.navigationController?.navigationBar.tintColor = UIColor.fy.white
        self.navigationController?.navigationBar.isTranslucent = false
    }

    func setupUI() {
        self.tableView.backgroundColor = UIColor.fy.backgroundGray
        // 美化：隐藏默认分隔线，用 cell 间留白实现分隔
        self.tableView.separatorStyle = .none
        // 美化：行高 70 → 76，更舒展
        self.tableView.rowHeight = 76
        self.tableView.sectionHeaderHeight = 0
        // 美化：section 间隔 8 → 10，cell 间呼吸
        self.tableView.sectionFooterHeight = 10
    }

    func setupBindings() {
        // 点击会话（演示用，后续可扩展为聊天页面）
        viewModel.sessionSelected
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { session in
                print("[Chat] session tapped: \(session.username ?? "")")
            }).disposed(by: rx.disposeBag)
    }

    func setupViewModel() {
        viewModel.request()
    }
}
