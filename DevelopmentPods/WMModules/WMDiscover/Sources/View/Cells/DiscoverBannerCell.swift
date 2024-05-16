//
//  DiscoverBannerCell.swift
//  WMDiscover
//
//  Created by Condy on 2023/10/7.
//

import Foundation
import FeatBox
import FSPagerView

class DiscoverBannerCell: BaseTableViewCell, HasDisposeBag {
    
    let tapIndex = PublishRelay<Int>()
    
    private let datas = PublishRelay<[Banner]>()
    
    var banners: [Banner] = [] {
        didSet {
            if oldValue == banners {
                return
            }
            if banners.count == 1, banners[0].fixedHeight ?? false {
                pagerView.snp.remakeConstraints { make in
                    make.top.equalToSuperview()
                    make.left.right.equalToSuperview().inset(20)
                    make.height.equalTo(banners[0].height ?? 50)
                }
            }
            //pageControl.numberOfPages = items.count
            //pagerView.reloadData()
            self.datas.accept(banners)
        }
    }
    
    private lazy var pagerView: FSPagerView = {
        let pagerView = FSPagerView(frame: .zero)
        pagerView.backgroundColor = UIColor.fy.mainColor
        //pagerView.dataSource = self
        //pagerView.delegate = self
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: FSPagerViewCell.fy.class_name)
        pagerView.automaticSlidingInterval = 3.0
        pagerView.isInfinite = true
        pagerView.removesInfiniteLoopForSingleItem = true
        return pagerView
    }()
    
    private lazy var pageControl: FSPageControl = {
        let pageControl = FSPageControl(frame: CGRect.zero)
        pageControl.currentPage = 0
        pageControl.hidesForSinglePage = true
        return pageControl
    }()
    
    override func setupConstraint() {
        contentView.addSubview(pagerView)
        pagerView.addSubview(pageControl)
        pagerView.bringSubviewToFront(pageControl)
        pagerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(Ces.width * 200 / 375)
        }
        pageControl.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(pagerView)
            make.height.equalTo(40)
        }
    }
    
    override func setupBindings() {
        pagerView.rx.didSelectItemAtIndex.bind(to: tapIndex).disposed(by: rx.disposeBag)
        pagerView.rx.pagerViewDidScroll.bind(to: pageControl.rx.currentPage).disposed(by: rx.disposeBag)
        
        datas.map { $0.count }.bind(to: pageControl.rx.numberOfPages).disposed(by: rx.disposeBag)
        
        datas.bind(to: pagerView.rx.items(cellIdentifier: FSPagerViewCell.fy.class_name)) { index, element, cell in
            cell.imageView?.fy.setImage(with: element.imagePath)
        }.disposed(by: rx.disposeBag)
    }
}

//extension DiscoverBannerCell: FSPagerViewDataSource {
//    
//    func numberOfItems(in pagerView: FSPagerView) -> Int {
//        return items.count
//    }
//    
//    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
//        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: FSPagerViewCell.fy.class_name, at: index)
//        cell.imageView?.fy.setImage(with: items[index].imagePath)
//        return cell
//    }
//}
//
//extension DiscoverBannerCell: FSPagerViewDelegate {
//    
//    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
//        pagerView.deselectItem(at: index, animated: false)
//        self.tapIndex.accept(index)
//    }
//    
//    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
//        guard let pageControl = pagerView.subviews.last as? FSPageControl else {
//            return
//        }
//        pageControl.currentPage = index
//    }
//}
