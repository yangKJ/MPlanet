//
//  DiscoverViewController.swift
//  WMDiscover
//
//  Created by Condy on 2020/12/28.
//

import FeatBox
import Harbeth
import FSPagerView
import RxDataSources

class DiscoverViewController: BaseTableViewController<DiscoverViewModel> {
    
    private var itmes: [Banner] = [] {
        didSet {
            pageControl.numberOfPages = itmes.count
            pagerView.reloadData()
        }
    }
    
    lazy var dataSource: RxTableViewSectionedReloadDataSource<DiscoverSection> = {
        return RxTableViewSectionedReloadDataSource(configureCell: { [weak self] (ds, tableView, indexPath, sectionItem) in
            switch sectionItem {
            case .progress(let item):
                let cell = tableView.fy.dequeueReusableCell(DiscoverProgressCell.self)
                cell.items = item
                return cell
            }
        })
    }()
    
    private lazy var pagerView: FSPagerView = {
        let pagerView = FSPagerView(frame: .zero)
        pagerView.backgroundColor = UIColor.fy.mainColor
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: FSPagerViewCell.fy.class_name)
        pagerView.automaticSlidingInterval = 3.0
        pagerView.isInfinite = true
        return pagerView
    }()
    
    private lazy var pageControl: FSPageControl = {
        let pageControl = FSPageControl(frame: CGRect.zero)
        pageControl.currentPage = 0
        pageControl.hidesForSinglePage = true
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInit()
        self.setupUI()
        self.setupBinding()
    }
    
    override func registerTableViewCell() -> [BaseTableViewCell.Type] {
        return [
            DiscoverProgressCell.self,
        ]
    }
    
    func setupInit() {
        self.title = Res.text("首页")
        self.navigationItem.leftBarButtonItem = nil
    }
    
    func setupUI() {
        tableView.estimatedRowHeight = (Ces.width) * 200 / 375
        pagerView.frame = CGRect(x: 0, y: 0, width: Ces.width, height: (Ces.width) * 200 / 375)
        tableView.tableHeaderView = pagerView
        pagerView.addSubview(pageControl)
        pagerView.bringSubviewToFront(pageControl)
        pageControl.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(pagerView)
            make.height.equalTo(40)
        }
    }
    
    func setupBinding() {
        // 绑定数据
        viewModel.outputs.datas
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
        
        // 轮播图数据驱动
        viewModel.outputs.banners.bind(to: rx.itmes).disposed(by: rx.disposeBag)
        // 是否显示轮播图
        if let header = self.tableView.tableHeaderView {
            viewModel.outputs.banners.map { $0.isEmpty }
                .bind(to: header.rx.isHidden).disposed(by: rx.disposeBag)
        }
        
        // 请求数据
        viewModel.inputs.request()
    }
}

extension DiscoverViewController: FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return itmes.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: FSPagerViewCell.fy.class_name, at: index)
        cell.imageView?.fy.setImage(with: itmes[index].imagePath)
        return cell
    }
}

extension DiscoverViewController: FSPagerViewDelegate {
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: false)
        let vc = BannerDetailViewController()
        vc.index = index
        vc.list = itmes
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        guard let pageControl = pagerView.subviews.last as? FSPageControl else {
            return
        }
        pageControl.currentPage = index
    }
}

extension DiscoverViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSource[indexPath].itemHeight
    }
}

extension DiscoverViewController: DZNEmptyDataSetable {
    
    func DZNEmptyDataSetImage(scrollView: UIScrollView) -> UIImage {
        Res.base_network_error_black
    }
    
    func DZNEmptyDataSetImageTintColor(scrollView: UIScrollView) -> UIColor? {
        return UIColor.fy.mainColor
    }
}
