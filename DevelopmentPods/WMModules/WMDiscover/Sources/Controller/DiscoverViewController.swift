//
//  DiscoverViewController.swift
//  WMDiscover
//
//  Created by Condy on 2020/12/28.
//

import FeatBox
import Harbeth
import FSPagerView

class DiscoverViewController: VMTableViewController<DiscoverViewModel> {
    
    private let filters: [C7FilterProtocol] = [
        C7SoulOut(soul: 0.75),
        C7Storyboard(ranks: 2),
    ]
    
    private var itmes: [Banner] = [] {
        willSet {
            pageControl.numberOfPages = newValue.count
            pagerView.reloadData()
        }
    }
    
    private lazy var pagerView: FSPagerView = {
        let pagerView = FSPagerView(frame: .zero)
        pagerView.backgroundColor = UIColor.cdy.mainColor
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: FSPagerViewCell.cdy.className)
        pagerView.automaticSlidingInterval = 3.0
        pagerView.isInfinite = true
        return pagerView
    }()
    
    private lazy var pageControl: FSPageControl = {
        let pageControl = FSPageControl(frame: CGRect.zero)
        pageControl.numberOfPages = itmes.count
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
    
    func setupInit() {
        self.title = R.text("首页")
        self.navigationItem.leftBarButtonItem = nil
    }
    
    func setupUI() {
        tableView.estimatedRowHeight = (C.width) * 9 / 16
        pagerView.frame = CGRect(x: 0, y: 0, width: C.width, height: (C.width) * 9 / 16)
        tableView.tableHeaderView = pagerView
        pagerView.addSubview(pageControl)
        pagerView.bringSubviewToFront(pageControl)
        pageControl.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(pagerView)
            make.height.equalTo(40)
        }
    }
    
    func setupBinding() {
        viewModel.inputs.loadData()
        
        // 轮播图数据驱动
        viewModel.outputs.banners.bind(to: rx.itmes).disposed(by: disposeBag)
        // 是否显示轮播图
        viewModel.outputs.banners
            .map { $0.isEmpty }
            .subscribe { [weak self] in
                self?.tableView.tableHeaderView?.isHidden = $0
            }.disposed(by: rx.disposeBag)
    }
}

extension DiscoverViewController: FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return itmes.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: FSPagerViewCell.cdy.className, at: index)
        if let imagePath = itmes[index].imagePath {
            if (itmes[index].id ?? 0) == 20 {
                cell.imageView?.cdy.setImage(with: imagePath, module: DiscoverUtil.moduleName, contentMode: .scaleAspectFill)
            } else {
                cell.imageView?.cdy.setImage(with: imagePath, module: DiscoverUtil.moduleName, filters: filters)
            }
        }
        return cell
    }
}

extension DiscoverViewController: FSPagerViewDelegate {
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: false)
        let item = itmes[index]
    }
    
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        guard let pageControl = pagerView.subviews.last as? FSPageControl else {
            return
        }
        pageControl.currentPage = index
    }
}
