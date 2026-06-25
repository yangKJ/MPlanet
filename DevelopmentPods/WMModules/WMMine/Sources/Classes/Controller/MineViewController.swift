//
//  MineViewController.swift
//  WMMine
//
//  Created by Condy on 2020/12/28.
//

import UIKit
import SnapKit
import FeatBox
import RxCocoa

class MineViewController: BaseTableViewController<MineViewModel> {
    
    public var userId: String?
    
    // 导航栏背景视图
    var barImageView: UIView?
    
    lazy var settingBarButton: UIButton = {
        let button = BaseButton(frame: .zero)
        let image = Res.image("icon_settings").c7.tinted(color: .fy.black)
            .c7.resized(with: CGSize(width: 22, height: 22), mode: .scaleAspectFit)
        button.setImage(image, for: .normal)
        //button.imageView?.tintColor = UIColor.fy.black
        return button
    }()
    
    lazy var messageBarButton: UIButton = {
        let button = BaseButton(frame: .zero)
        let image = Res.image("icon_activity").c7.tinted(color: .fy.black)
            .c7.resized(with: CGSize(width: 22, height: 22), mode: .scaleAspectFit)
        button.setImage(image, for: .normal)
        //button.imageView?.tintColor = UIColor.fy.black
        return button
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.barImageView?.backgroundColor = UIColor.fy.clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 美化：保留 setupNavigationBar 里的渐变图，不要在 willAppear 里清掉
        // 原来 setBackgroundImage(UIImage()) 是给 scroll-up 时留白用,现改为用 scrollEdgeAppearance 控制
        self.navigationController?.navigationBar.shadowImage = UIImage()

        // 修复：状态栏文字白色。iOS 13+ 用 barStyle=.black 触发白字 status bar
        self.navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //重置导航栏背景
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.setupUI()
        self.setupViewModel()
        self.setupBindings()
    }
    
    func setupNavigationBar() {
        let barButton1 = UIBarButtonItem(customView: messageBarButton)
        let barButton2 = UIBarButtonItem(customView: settingBarButton)
        //按钮间的空隙
        let gap = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        gap.width = 10
        //用于消除右边边空隙，要不然按钮顶不到最边上
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = -10
        self.navigationItem.rightBarButtonItems = [spacer, barButton2, gap, barButton1]
        self.navigationItem.leftBarButtonItem = nil
        self.barImageView = self.navigationController?.navigationBar.subviews.first
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.barTintColor = UIColor.fy.mainColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.fy.white
        // 美化：标题白色 bold_18，与 wallet/Discover 视觉语言统一
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.fy.white,
            .font: UIFont.fy.bold_18
        ]
        // 美化：渐变背景图（主色绿 → 主色绿 0.78，对角 45°）
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.fy.mainColor.cgColor,
            UIColor.fy.mainColor.withAlphaComponent(0.78).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 88)
        UIGraphicsBeginImageContextWithOptions(gradient.bounds.size, false, 0)
        gradient.render(in: UIGraphicsGetCurrentContext()!)
        let bgImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.navigationController?.navigationBar.setBackgroundImage(bgImage, for: .default)
    }
    
    func setupUI() {
        // 美化：与 Discover 视觉语言对齐，tableView 用浅灰背景，header cell 自带渐变绿卡片
        self.tableView.backgroundColor = UIColor.fy.backgroundGray
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 0
        self.tableView.estimatedSectionFooterHeight = 0
        self.tableView.estimatedSectionHeaderHeight = 0
    }
    
    func setupViewModel() {
        self.viewModel.requestUserInfo(with: self.userId)
    }
    
    func setupBindings() {
        if let header = tableView.mj_header {
            emptyDataSetViewTap.bind(to: header.rx.beginRefreshing).disposed(by: rx.disposeBag)
        }
        
        headerRefreshing.subscribe(onNext: { [weak self] _ in
            self?.viewModel.requestUserInfo(with: self?.userId)
        }).disposed(by: rx.disposeBag)
        
        tableView.rx.didScroll.subscribe(onNext: { [weak self] _ in
            let offset = self?.tableView.contentOffset.y ?? 0.0
            var delta = offset / 64.0
            delta = CGFloat.maximum(delta, 0)
            delta = CGFloat.minimum(delta, 1)
            self?.barImageView?.backgroundColor = UIColor.fy.mainColor.withAlphaComponent(delta)
            self?.navigationTitle = delta > 0.9 ? Res.text("个人中心") : ""
        }).disposed(by: rx.disposeBag)
        
        // 消息中心
        messageBarButton.rx.tap.subscribe(onNext: { [weak self] _ in
            
        }).disposed(by: rx.disposeBag)
        
        // 设置中心
        settingBarButton.rx.tap.subscribe(onNext: { [weak self] _ in
            let auth = LoginAuthVerification()
            auth.startDestinationAction(destinationActionWhenUICompletion: true, action: { [weak self] _ in
                let vc = MineSettingViewController()
                vc.users = self?.viewModel.users.value
                self?.navigationController?.pushViewController(vc, animated: true)
            })
        }).disposed(by: rx.disposeBag)
        
        // 世界排行榜
        self.viewModel.rankingEvent.subscribe(onNext: { [weak self] _ in
            print("世界排行榜")
        }).disposed(by: rx.disposeBag)
        
        // 上传照片
        self.viewModel.tapUploadPhoto.subscribe(onNext: { [weak self] co in
            print("还可上传\(co)张照片")
        }).disposed(by: rx.disposeBag)
        
        // 签到
        self.viewModel.signInEvent.subscribe(onNext: { [weak self] _ in
            let vc = FSCalendarViewController<MineSignInCalendarCell>.init(calendarHeight: 370.0)
            let max = Date().fy.endOfMonth().fy.monthLater(with: 1)
            let min = max.fy.yearAgo(with: 1)
            vc.minDate = min
            vc.maxDate = max
            vc.titleLabelText = Res.text("签到日历")
            vc.request(block: { [weak self] date, block in
                self?.viewModel.requestCalendar(date: date, complete: block)
            })
            vc.show()
        }).disposed(by: rx.disposeBag)
        
        // 更多帖子
        self.viewModel.tapPostMoreEvent.subscribe(onNext: { [weak self] in
            
        }).disposed(by: rx.disposeBag)
    }
}
