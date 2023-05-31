//
//  BannerDetailTopCell.swift
//  WMDiscover
//
//  Created by Condy on 2023/5/29.
//

import Foundation
import FeatBox

class BannerDetailTopCell: BaseTableViewCell, HasDisposeBag, UICollectionViewDelegate {
    
    typealias BannerAndIndexType = (index: Int?, banners: [Banner])
    public let bannersAndIndex = BehaviorRelay<BannerAndIndexType>(value: (0, []))
    public let currentIndex = PublishRelay<Int>()
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
        layout.minimumLineSpacing = 15
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: C.width - 60, height: (C.width-60)*250.0/375.0)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.isScrollEnabled = true
        view.delegate = self
        view.clipsToBounds = false
        view.ai.register(BannerDetailTopCellCollectionViewCell.self)
        return view
    }()
    
    override func setupConstraint() {
        self.clipsToBounds = false
        contentView.clipsToBounds = false
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            //make.top.bottom.equalToSuperview()
            //make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(collectionView.snp.width).multipliedBy(250.0/375.0).priority(999)
        }
    }
    
    override func setupBindings() {
        
        bannersAndIndex.map { $0.banners }
            .bind(to: collectionView.rx.items) { (collectionView, row, element) in
                let indexPath = IndexPath(row: row, section: 0)
                let item = collectionView.ai.dequeueReusableCell(BannerDetailTopCellCollectionViewCell.self, indexPath: indexPath)
                item.banner = element
                item.backgroundColor = UIColor.ai.random
                return item
            }.disposed(by: rx.disposeBag)
        
        bannersAndIndex
            .delaySubscription(.milliseconds(10), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let index = $0.index, $0.banners.count > index else {
                    return
                }
                let indexPath = IndexPath(row: index, section: 0)
                self?.collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
            }).disposed(by: rx.disposeBag)
    }
    
    private func index(for cell: UICollectionViewCell) -> Int {
        guard let indexPath = self.collectionView.indexPath(for: cell) else {
            return NSNotFound
        }
        return indexPath.item
    }
    
    //MARK: - UICollectionViewDelegate
    
    private var index_ = 0
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.index_ = indexPath.item
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.currentIndex.accept(self.index_)
    }
}

fileprivate class BannerDetailTopCellCollectionViewCell: BaseCollectionViewCell {
    
    var banner: Banner? {
        didSet {
            guard let banner = banner else {
                return
            }
            titleLabel.text = banner.title
            if let imagePath = banner.imagePath {
                backImageView.ai.setImage(with: imagePath, module: DiscoverUtil.moduleName, contentMode: .scaleAspectFill)
            }
        }
    }
    
    lazy var backImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = DynamicFontSizeLabel.init()
        label.font = UIFont.ai.system_20
        label.textColor = UIColor.ai.title
        return label
    }()
    
    override func setupConstraint() {
        contentView.addSubview(backImageView)
        backImageView.addSubview(titleLabel)
        backImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
