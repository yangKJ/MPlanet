//
//  MineSettingViewController.swift
//  WMMine
//
//  Created by Condy on 2023/6/6.
//

import Foundation
import SnapKit
import FeatBox
import RxCocoa

class MineSettingViewController: BaseTableViewController<MineSettingViewModel> {
    
    public var users: MineUsers? {
        didSet {
            guard let users = users else {
                return
            }
            self.avatarImageView?.fy.setImage(with: users.avatar_url)
        }
    }
    
    lazy var headerImageView: UIView = {
        // 美化：从单纯 headerImageView 升级为 headerContainer + 圆形头像 + 渐变背景
        let container = BaseView(frame: CGRect(x: 0, y: 0, width: Constants.width, height: 200))
        // 渐变背景（主色绿 → 主色绿 0.85，对角）
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.fy.mainColor.cgColor,
            UIColor.fy.mainColor.withAlphaComponent(0.85).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = container.bounds
        container.layer.insertSublayer(gradient, at: 0)

        // 圆形头像
        let avatar = BaseImageView()
        avatar.frame = CGRect(x: 0, y: 0, width: 72, height: 72)
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = 36
        avatar.layer.borderWidth = 3
        avatar.layer.borderColor = UIColor.fy.white.cgColor
        avatar.backgroundColor = UIColor.fy.white
        container.addSubview(avatar)
        avatar.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-8)
            make.width.height.equalTo(72)
        }
        // 给外部设置图片用
        objc_setAssociatedObject(container,
                                 &MineSettingViewController.avatarKey,
                                 avatar,
                                 .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return container
    }()
    private static var avatarKey: UInt8 = 0

    /// 便捷访问 header 里的圆形头像
    var avatarImageView: UIImageView? {
        objc_getAssociatedObject(headerImageView, &MineSettingViewController.avatarKey) as? UIImageView
    }

    lazy var footerView: UIView = {
        let view = BaseView(frame: CGRect(x: 0, y: 0, width: Constants.width, height: 80))
        // 美化：外层灰背景
        view.backgroundColor = UIColor.fy.backgroundGray
        var label = BaseLabel.init()
        label.text = Res.text("退出登陆")
        label.textAlignment = .center
        label.font = UIFont.fy.bold_18
        label.textColor = UIColor.fy.lightRed
        label.fy.cornerRadius = 10
        label.fy.corOfShadow = 10
        label.backgroundColor = UIColor.fy.white
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInit()
        self.setupUI()
        self.setupViewModel()
        self.setupBindings()
    }

    func setupInit() {
        self.navigationTitle = Res.text("设置中心")
    }

    func setupUI() {
        // 美化：与 Discover 一致，rowHeight 56（标准列表项），隐藏分隔线，背景灰
        tableView.rowHeight = 56
        tableView.backgroundColor = UIColor.fy.backgroundGray
        tableView.separatorStyle = .none
        tableView.tableHeaderView = headerImageView
        tableView.tableFooterView = footerView
    }
    
    func setupViewModel() {
        self.viewModel.setupFunctionForm(with: users)
    }
    
    func setupBindings() {
        // 点击事件
        viewModel.tapIndexFunctionForm.subscribe(onNext: { [weak self] element in
            guard let vc = element.gotoViewController(with: self?.users) else {
                return
            }
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: rx.disposeBag)
        
        // 退出登陆
        footerView.rx.tapGesture()
            .when(.recognized)
            .flatMapLatest({ _ in
                Methods.logout()
            })
            .subscribe(onNext: { [weak self] _ in
                Session.shared.logout()
                Methods.gotoMineViewController()
            }).disposed(by: rx.disposeBag)
    }
}
