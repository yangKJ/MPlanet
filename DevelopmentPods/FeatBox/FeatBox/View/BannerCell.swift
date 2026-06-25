//
//  BannerCell.swift
//  FeatBox
//
//  Created by Condy on 2024/5/20.
//

import Foundation
import FSPagerView
import RxCocoa
import ProductLib
import SnapKit

public final class BannerCellViewModel: BaseTableViewCellViewModelable {
    
    public var cellType: BaseTableViewCell.Type {
        BannerCell.self
    }
    
    public var goto: Bool = true
    public var insets: UIEdgeInsets = .zero
    
    fileprivate var tapIndexBlock: ((Int) -> Void)?
    public func setTapIndex(block: ((Int) -> Void)?) {
        self.tapIndexBlock = block
    }
    
    public init() { }
}

public final class BannerCell: BaseTableViewCell, HasDisposeBag {
    
    /// 非整数会出现布局变化问题，Will attempt to recover by breaking constraint
    private let pagerViewHeight = Int(Constants.width * 200.0 / 375.0)
    
    private var banners: [Banner] = []
    
    public override var viewModel: (any BaseTableViewCellViewModelable)? {
        didSet {
            guard let viewModel = viewModel as? BannerCellViewModel else {
                return
            }
            self.banners = viewModel.datasource as? [Banner] ?? []
            self.pageControl.numberOfPages = self.banners.count
            self.setupPagerView(insets: viewModel.insets, banners: banners)
            self.pagerView.reloadData()
        }
    }
    
    public lazy var pagerView: FSPagerView = {
        let pagerView = FSPagerView(frame: .zero)
        pagerView.backgroundColor = UIColor.fy.mainColor
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: FSPagerViewCell.fy.class_name)
        pagerView.automaticSlidingInterval = 3.0
        pagerView.isInfinite = true
        pagerView.removesInfiniteLoopForSingleItem = true
        return pagerView
    }()
    
    public lazy var pageControl: FSPageControl = {
        let pageControl = FSPageControl(frame: CGRect.zero)
        pageControl.currentPage = 0
        pageControl.hidesForSinglePage = true
        return pageControl
    }()
    
    public override func setupConstraint() {
        self.selectionStyle = .none
        contentView.addSubview(pagerView)
        pagerView.addSubview(pageControl)
        pagerView.bringSubviewToFront(pageControl)
        pagerView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
            make.height.equalTo(pagerViewHeight)
        }
        pageControl.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(pagerView)
            make.height.equalTo(40)
        }
    }
    
    public override func setupBindings() {
        // 死代码清理：原先 4 段 binding 代码全部注释未启用，全部删掉避免误导。
        // 真实数据绑定逻辑由 FSPagerView 的 dataSource / delegate 承担（见下方 extension）。
    }
    
    private func setupPagerView(insets: UIEdgeInsets, banners: [Banner]) {
        guard pagerView.superview != nil else {
            return
        }
        self.pagerView.snp.remakeConstraints { (make) in
            make.left.equalTo(insets.left)
            make.right.equalTo(-insets.right)
            make.top.equalTo(insets.top)
            make.bottom.equalTo(-insets.bottom)
            if banners.count == 1, banners[0].fixedHeight {
                make.height.equalTo(banners[0].height ?? 50)
            } else {
                make.height.equalTo(pagerViewHeight)
            }
        }
    }
    
    private func gotoIndex(_ index: Int) {
        pagerView.deselectItem(at: index, animated: false)
        guard let viewModel = viewModel as? BannerCellViewModel else {
            return
        }
        if viewModel.goto {
            self.banners[safe: index]?.goto(additional: [
                "index": index,
                "banners": self.banners,
            ])
        } else {
            viewModel.tapIndexBlock?(index)
        }
    }
}

extension BannerCell: FSPagerViewDataSource {
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return banners.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: FSPagerViewCell.fy.class_name, at: index)
        cell.imageView?.fy.setImage(with: banners[index].imagePath)
        return cell
    }
}

extension BannerCell: FSPagerViewDelegate {
    
    public func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        self.gotoIndex(index)
    }
    
    public func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        pageControl.currentPage = index
    }
}
