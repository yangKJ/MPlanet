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
import RxDataSources

class MineViewController: BaseTableViewController<MineViewModel> {
    
    public var userId: String?
    
    private let rankingEvent = PublishRelay<Void>()
    private let tapUploadPhoto = PublishRelay<Int>()
    private let signInEvent = PublishRelay<Void>()
    
    // 导航栏背景视图
    var barImageView: UIView?
    
    lazy var dataSource: RxTableViewSectionedReloadDataSource<MineUsersSection> = {
        return RxTableViewSectionedReloadDataSource(configureCell: { [weak self] (ds, tableView, indexPath, sectionItem) in
            switch sectionItem {
            case .header(let item):
                let cell = tableView.fy.dequeueReusableCell(MineUsersHeaderCell.self)
                cell.users.accept(item)
                if let weakself = self {
                    cell.disposeBag = DisposeBag()
                    cell.signInEvent.bind(to: weakself.signInEvent).disposed(by: cell.disposeBag)
                }
                return cell
            case .photo(let item):
                let cell = tableView.fy.dequeueReusableCell(MineUsersPhotoCell.self)
                cell.photos.accept(item)
                if let weakself = self {
                    cell.disposeBag = DisposeBag()
                    cell.tapUploadPhoto.bind(to: weakself.tapUploadPhoto).disposed(by: cell.disposeBag)
                }
                return cell
            case .ranking(let item):
                let cell = tableView.fy.dequeueReusableCell(MineUsersRankingCell.self)
                cell.name = item
                if let weakself = self {
                    cell.disposeBag = DisposeBag()
                    cell.rx.tapCell.bind(to: weakself.rankingEvent).disposed(by: cell.disposeBag)
                }
                return cell
            case .posts(let item):
                let cell = tableView.fy.dequeueReusableCell(MineUsersPostsCell.self)
                cell.posts.accept(item)
                return cell
            }
        })
    }()
    
    lazy var settingBarButton: UIButton = {
        let button = BaseButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        button.setImage(Res.image("icon_settings").c7.tinted(color: .fy.black), for: .normal)
        //button.imageView?.tintColor = UIColor.fy.black
        return button
    }()
    
    lazy var messageBarButton: UIButton = {
        let button = BaseButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        button.setImage(Res.image("icon_activity").c7.tinted(color: .fy.black), for: .normal)
        //button.imageView?.tintColor = UIColor.fy.black
        return button
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.barImageView?.backgroundColor = UIColor.fy.clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //设置导航栏背景透明
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //重置导航栏背景
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInit()
        self.setupNavigationBar()
        self.setupUI()
        self.setupViewModel()
        self.setupBindings()
    }
    
    override func registerTableViewCell() -> [BaseTableViewCell.Type] {
        return [
            MineUsersHeaderCell.self,
            MineUsersPhotoCell.self,
            MineUsersRankingCell.self,
            MineUsersPostsCell.self
        ]
    }
    
    override func tableViewCellHeight(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSource[indexPath].itemHeight
    }
    
    func setupInit() {
        self.navigationItem.leftBarButtonItem = nil
        self.barImageView = self.navigationController?.navigationBar.subviews.first
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.barTintColor = UIColor.fy.mainColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.fy.white
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.fy.white]
    }
    
    func setupNavigationBar() {
        let barButton1 = UIBarButtonItem(customView: messageBarButton)
        let barButton2 = UIBarButtonItem(customView: settingBarButton)
        //按钮间的空隙
        let gap = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        gap.width = 15
        //用于消除右边边空隙，要不然按钮顶不到最边上
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = -10
        self.navigationItem.rightBarButtonItems = [spacer, barButton2, gap, barButton1]
    }
    
    func setupUI() {
        self.tableView.backgroundColor = UIColor.fy.mainColor
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.snp.remakeConstraints { make in
            make.top.equalTo(self.view.snp.topMargin)
            make.bottom.equalTo(self.view.snp.bottomMargin)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func setupViewModel() {
        // 错误提示
        viewModel.outputs.datas.subscribe(onError: { [weak self] error in
            self?.view.fy.showHUD(title: error.localizedDescription)
        }).disposed(by: rx.disposeBag)
        
        // 绑定数据
        viewModel.outputs.datas
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
        
        self.viewModel.inputs.requestUserInfo(with: self.userId)
    }
    
    func setupBindings() {
        if let header = tableView.mj_header {
            emptyDataSetViewTap.bind(to: header.rx.beginRefreshing).disposed(by: rx.disposeBag)
        }
        
        headerRefreshing.subscribe { [weak self] _ in
            self?.viewModel.inputs.requestUserInfo(with: self?.userId)
        }.disposed(by: rx.disposeBag)
        
        tableView.rx.didScroll.subscribe(onNext: { [weak self] _ in
            let offset = self?.tableView.contentOffset.y ?? 0
            var delta = offset / 64
            delta = CGFloat.maximum(delta, 0)
            delta = CGFloat.minimum(delta, 1)
            self?.barImageView?.backgroundColor = UIColor.fy.mainColor.withAlphaComponent(delta)
            self?.title = delta > 0.9 ? Res.text("个人中心") : ""
        }).disposed(by: rx.disposeBag)
        
        // 消息中心
        messageBarButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            Session.shared.logout()
        }).disposed(by: rx.disposeBag)
        
        // 设置中心
        settingBarButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            let auth = LoginAuthVerfication()
            auth.startDestinationAction(destinationActionWhenUICompletion: true, action: { [weak self] _ in
                let vc = MineSettingViewController()
                vc.users = self?.viewModel.users.value
                self?.navigationController?.pushViewController(vc, animated: true)
            })
        }).disposed(by: rx.disposeBag)
        
        // 世界排行榜
        self.rankingEvent.subscribe(onNext: { [weak self] _ in
            print("世界排行榜")
        }).disposed(by: rx.disposeBag)
        
        // 上传照片
        self.tapUploadPhoto.subscribe(onNext: { [weak self] co in
            print("还可上传\(co)张照片")
        }).disposed(by: rx.disposeBag)
        
        // 签到
        self.signInEvent.subscribe(onNext: { [weak self] _ in
            let vc = FSCalenderViewController<MineSignInCalenderCell>.init(calenderHeight: 370.0)
            let max = Date().fy.endOfMonth().fy.monthLater(with: 1)
            let min = max.fy.yearAgo(with: 1)
            vc.minDate = min
            vc.maxDate = max
            vc.titleLabelText = Res.text("签到日历")
            vc.request(block: { [weak self] date, block in
                self?.viewModel.requestCalender(date: date, complete: { result in
                    let days = Dictionary.init(result?.compactMap {
                        $0.sysDate != nil ? ($0.sysDate!, $0) : nil
                    } ?? []) { $1 }
                    block(days)
                })
            })
            vc.show()
        }).disposed(by: rx.disposeBag)
    }
}

extension MineViewController: DZNEmptyDataSetable {
    
    func DZNEmptyDataSetImage(scrollView: UIScrollView) -> UIImage {
        Res.base_network_error_black
    }
    
    func DZNEmptyDataSetImageTintColor(scrollView: UIScrollView) -> UIColor? {
        return UIColor.fy.mainColor
    }
}
