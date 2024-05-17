//
//  DiscoverViewController.swift
//  WMDiscover
//
//  Created by Condy on 2020/12/28.
//

import FeatBox
import RxDataSources

class DiscoverViewController: BaseTableViewController<DiscoverViewModel> {
    
    let tapBannerIndex = PublishRelay<(Int, [Banner])>()
    
    lazy var dataSource: RxTableViewSectionedReloadDataSource<DiscoverSection> = {
        return RxTableViewSectionedReloadDataSource(configureCell: { [weak self] (ds, tableView, indexPath, sectionItem) in
            switch sectionItem {
            case .banner(let items):
                let cell = tableView.fy.dequeueReusableCell(DiscoverBannerCell.self)
                cell.banners = items
                if let weakself = self {
                    cell.disposeBag = DisposeBag()
                    cell.tapIndex.map({
                        ($0, items)
                    }).bind(to: weakself.tapBannerIndex).disposed(by: cell.disposeBag)
                }
                return cell
            case .videoClassify(let item):
                let cell = tableView.fy.dequeueReusableCell(DiscoverVideoClassifyCell.self)
                cell.items = item
                return cell
            case .decorativeRail(let item):
                let cell = tableView.fy.dequeueReusableCell(DiscoverDecorativeRailCell.self)
                cell.items = item
                return cell
            }
        })
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInit()
        self.setupUI()
        self.setupBinding()
    }
    
    override func registerTableViewCell() -> [BaseTableViewCell.Type] {
        return [
            DiscoverBannerCell.self,
            DiscoverVideoClassifyCell.self,
            DiscoverDecorativeRailCell.self,
        ]
    }
    
    func setupInit() {
        self.title = Res.text("首页")
        self.navigationItem.leftBarButtonItem = nil
    }
    
    func setupUI() {
        //tableView.estimatedRowHeight = (Ces.width) * 200 / 375
    }
    
    func setupBinding() {
        // 绑定数据
        viewModel.outputs.sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
        
        // 点击Banner
        tapBannerIndex.subscribe(onNext: { [weak self] index, banners in
            banners[safe: index]?.goto(from: self, additional: [
                "index": index,
                "banners": banners
            ])
        }).disposed(by: rx.disposeBag)
        
        // 请求数据
        viewModel.inputs.request()
    }
}

extension DiscoverViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSource[indexPath].itemHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return dataSource[section].headerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return dataSource[section].headerView
    }
}

extension DiscoverViewController: DZNEmptyDataSetable {
    
    func DZNEmptyDataSetImage(scrollView: UIScrollView) -> UIImage {
        Res.no_search_result_image
    }
    
    func DZNEmptyDataSetImageTintColor(scrollView: UIScrollView) -> UIColor? {
        return UIColor.fy.mainColor
    }
}
