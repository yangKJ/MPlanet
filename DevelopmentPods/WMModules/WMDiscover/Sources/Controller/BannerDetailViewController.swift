//
//  BannerDetailViewController.swift
//  WMDiscover
//
//  Created by Condy on 2023/5/29.
//

import Foundation
import FeatBox
import RxDataSources

class BannerDetailViewController: BaseTableViewController<BannerDetailViewModel> {
    
    public var index: Int = 0
    public var list: [Banner] = []
    
    // 防止刷新列表变动
    private var topCell: BannerDetailTopCell?
    
    lazy var dataSource: RxTableViewSectionedReloadDataSource<BannerDetailSection> = {
        return RxTableViewSectionedReloadDataSource(configureCell: { [weak self] (ds, tableView, indexPath, sectionItem) in
            switch sectionItem {
            case .top(let item):
                if self?.topCell != nil {
                    return self!.topCell!
                }
                let cell = tableView.fy.dequeueReusableCell(BannerDetailTopCell.self)
                self?.topCell = cell
                if let weakself = self {
                    cell.disposeBag = DisposeBag() // 解决Cell重用导致订阅取消或者多次订阅问题
                    cell.currentIndex.bind(to: weakself.viewModel.currentIndex).disposed(by: cell.disposeBag)
                }
                cell.bannersAndIndex.accept((self?.index, item))
                return cell
            case .detail(let item):
                let cell = tableView.fy.dequeueReusableCell(BannerDetailCell.self)
                cell.detail.accept(item)
                return cell
            }
        })
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInit()
        self.setupSubviews()
        self.setupViewModel()
        self.setupBindings()
    }
    
    override func registerTableViewCell() -> [BaseTableViewCell.Type] {
        return [BannerDetailTopCell.self, BannerDetailCell.self]
    }
    
    func setupInit() {
        self.title = self.list[safe: self.index]?.title
    }
    
    func setupSubviews() {
        
    }
    
    func setupViewModel() {
        // 列表滚动监听
        viewModel.outputs.currentIndex.distinctUntilChanged()
            .subscribe(onNext: { [weak self] in
                print("index: - \($0)")
                self?.index = $0
                self?.viewModel.requestBannerDetail(with: $0, banners: self?.list)
            }).disposed(by: rx.disposeBag)
        
        // 监听卡列表变化
        viewModel.outputs.banners.subscribe(onNext: { [weak self] in
            self?.list = $0
        }).disposed(by: rx.disposeBag)
        
        // 卡详情数据
        viewModel.outputs.bannerDetail
            .map { $0?.title }
            .bind(to: self.rx.title)
            .disposed(by: rx.disposeBag)
        
        // 错误提示
        viewModel.outputs.datas.subscribe(onError: { [weak self] error in
            self?.view.fy.showHUD(title: error.localizedDescription)
        }).disposed(by: rx.disposeBag)
        
        // 绑定数据
        viewModel.outputs.datas
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
        
        //viewModel.outputs.isEmptyData.bind(to: tableView.rx.isHidden).disposed(by: rx.disposeBag)
        
        // 驱动网络请求
        viewModel.inputs.requestBannerDetail(with: self.index, banners: self.list)
    }
    
    func setupBindings() {
        
    }
}

extension BannerDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSource[indexPath].itemHeight
    }
}

extension BannerDetailViewController: DZNEmptyDataSetable {
    
    func DZNEmptyDataSetImage(scrollView: UIScrollView) -> UIImage {
        Res.base_network_error_black
    }
    
    func DZNEmptyDataSetImageTintColor(scrollView: UIScrollView) -> UIColor? {
        return UIColor.fy.mainColor
    }
}
